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

since_id = DB[:tweets].max(:id).to_i
ts = Time.now
new_tweets = client.search("from:greg_doucette", result_type: "recent", since_id: since_id + 1).collect.to_a.reverse
te = Time.now

puts "Fetched #{new_tweets.count} tweets in #{te - ts}s"
p [since_id]

new_tweets.each do |t|
  p [t.id, t.in_reply_to_status_id, t.created_at, t.text]
  next if (DB[:tweets].where(id: t.id.to_s).count > 0)
  if t.in_reply_to_status_id && (DB[:tweets].where(id: t.in_reply_to_status_id.to_s).count > 0)
     DB[:tweets] << {id: t.id.to_s, created_at: t.created_at, tweet: t.to_h.to_json }
  end
end

new_count = DB[:tweets].count

puts "#{original_count} -> #{new_count}"
