require 'http'
require 'nokogiri'

doc = Nokogiri(HTTP.get("http://twitter.com/greg_doucette").body.to_s)
doc.css('//a[@href*="/greg_doucette/status/"]').map {|el| el["href"] }

# TODO: go to town on each post id, skipping any that are not replies, following all reply tweets back to the Threadnaught
# (or to their rightful end)
