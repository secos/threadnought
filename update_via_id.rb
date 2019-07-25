require './config/boot.rb'

require 'twitter'

puts "Updating the 'nought"

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV["consumer_key"]
  config.consumer_secret     = ENV["consumer_secret"]
  config.access_token        = ENV["access_token"]
  config.access_token_secret = ENV["access_token_secret"]
end

original_count = DB[:tweets].count


id = ARGV[0]

loop do
  break if (DB[:tweets].where(id: id.to_s).count > 0)
  t = client.status id
  p [t.id, t.in_reply_to_status_id, t.created_at, t.text]
  DB[:tweets] << {id: t.id.to_s, created_at: t.created_at, tweet: t.to_h.to_json }
  id = t.in_reply_to_status_id
end

new_count = DB[:tweets].count

puts "#{original_count} -> #{new_count}"
