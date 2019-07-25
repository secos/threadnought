require 'twitter'
require 'json'
require 'hashie'

require 'sequel'

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV["consumer_key"]
  config.consumer_secret     = ENV["consumer_secret"]
  config.access_token        = ENV["access_token"]
  config.access_token_secret = ENV["access_token_secret"]
end

the_nought = {}

File.readlines("thenoughtcache").each do |l|
  status = Hashie::Mash.new JSON.load l
  the_nought[status.id] = status
end

puts "Starting cache: #{the_nought.size} tweets"

id = ARGV[0] || "1154223117293826049"
begin
  loop do
    if !(status = the_nought[id])
      status = client.status id
      break if status.user.id != 132029493
      # this is dumb, but whatevs
      status = Hashie::Mash.new status.to_h
      the_nought[status.id] = status
      sleep 0.9
    end

    id = status.in_reply_to_status_id
    p [the_nought.count, status.created_at, status.text ]
  end
rescue => ex
  puts ex
end
puts "Final Count: #{the_nought.size}"

File.open("thenoughtcache","w") {|f| the_nought.each {|k,v| f.puts v.to_json }}
