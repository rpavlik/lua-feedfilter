local FeedConstructor = require "feedfilter.feed"

cache_dir = "./tmp"

feed = function(self)
	return FeedConstructor(self)
end
