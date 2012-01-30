#!/usr/bin/env lua

require "luarocks.loader"

require "std"

require "feedfilter.configdsl"

local f = feed{
	url = "https://github.com/rpavlik.atom",
	name = "Ryan's GitHub activity"
}

local results = f:get()
--print(results)
print(#(results.entries))

local filtered = filter{
	predicate = function(entry)
		return entry.title:find("pull")
	end,
	f
}:get()

print(#(filtered.entries))
