local FeedConstructor = require "feedfilter.feed"
local filter = require "feedfilter.filter"
local generation = require "feedfilter.generate"

local verbose = require "feedfilter.verbose"

feed = function(self)
	if type(self) == "string" then
		return FeedConstructor({url = self})
	else
		return FeedConstructor(self)
	end
end

local createTransformFunction = function(transformName, constructor, membername)
	_G[transformName] = function(a)
		assert(a[membername], membername .. " must be non-nil")
		local member = a[membername]
		local result = {}
		verbose( ("Constructing %s with %d children"):format(transformName, #a) )
		for _, v in ipairs(a) do
			table.insert(result, constructor{source = v, [membername] = member})
		end
		return unpack(result)
	end
end

createTransformFunction("filter", filter.newFilter, "predicate")
createTransformFunction("map", filter.newMap, "mapfunc")

generate = function(args)
	local feedArgs = {}
	for k, v in pairs(args) do
		if type(k) ~= "number" or k > #args or k < 1 then
			feedArgs[k] = v
		end
	end
	if not feedArgs.selfUrl then
		feedArgs.selfUrl = feedArgs.baseUrl .. feedArgs.filename
	end
	if not feedArgs.id then
		feedArgs.id = feedArgs.selfUrl
	end

	verbose(("Retrieving and merging %d feeds"):format(#args))
	local newFeed = generation.mergeFeeds(feedArgs, args)

	verbose(("Generating new feed with %d entries"):format(#newFeed.entries))
	local output = generation.generateFeed(newFeed)

	verbose("Writing output to", feedArgs.filename)
	local f = assert(io.open(feedArgs.filename, 'w'))
	f:write(output)
	f:close()
	verbose("")
end
