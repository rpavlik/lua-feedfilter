local FeedConstructor = require "feedfilter.feed"
local FilterConstructor = require "feedfilter.filter"
cache_dir = "./tmp"

feed = function(self)
	return FeedConstructor(self)
end

filter = function(a)
	local pred = a.predicate
	local result = {}
	for _, v in ipairs(a) do
		table.insert(result, FilterConstructor{source = v, predicate = pred})
	end
	return unpack(result)
end
