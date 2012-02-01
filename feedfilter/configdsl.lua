---
-- Loading the feedfilter.configdsl module creates a number of global
-- functions intended to specify a domain-specific language for feed
-- aggregation, filtering, transformation, and re-generation. The command
-- `lua-feedfilter` takes `config.lua`, or any other file name(s) if
-- specified on the command line, and processes them individually in an
-- environment containing these functions in addition to the Lua
-- standard library.
--
-- @module feedfilter.configdsl


local FeedConstructor = require "feedfilter.feed"
local filter = require "feedfilter.filter"
local generation = require "feedfilter.generate"

local verbose = require "feedfilter.verbose"

--- Constructs a feed access table given a table containing at least a "url" value,
-- or a string to serve as the URL.
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


--- Filters entries in the given feeds by passing (entry, feed) to the
-- `predicate`, and only including entries for which the predicate returned
-- true.
--[[
function filter(args) end
]]
createTransformFunction("filter", filter.newFilter, "predicate")

--- Modifies entries in the given feeds by passing (entry, feed) to the
-- `mapfunc`, which may modify or replace the entry then return the entry
-- desired in the output.
--[[
function filter(args) end
]]
createTransformFunction("map", filter.newMap, "mapfunc")

--- Generates a new Atom 1.0 feed from the feeds and their remaining entries
-- as provided as unlabeled arguments.
--
-- Named arguments include:
--
-- - baseUrl
-- - filename - where output will be written.
-- - selfUrl (optional - defaults to baseUrl .. filename)
-- - id (optional - defaults to selfUrl)
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

---
-- A pre-made map for feeds that provide HTML in their content.
-- lua-feedparser seems to drop any reference to `<content type="html">`,
-- but this will trigger putting it back in the generated Atom feed.
markContentAsHTML = function(arg)
	arg.mapfunc = function(entry, feed)
		entry.contentHTML = true
		return entry
	end
	return map(arg)
end
