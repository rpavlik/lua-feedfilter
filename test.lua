#!/usr/bin/env lua

require "luarocks.loader"
require "std"
require "feedfilter.configdsl"

local f = feed{
	url = "https://github.com/rpavlik.atom",
	name = "Ryan's GitHub activity"
}

local results = f:get()
print("Format:", results.format)
print("Version:", results.version)
print()
print(results.entries[1])
print(results.feed)
print(#(results.entries))

local f2 = filter{
	predicate = function(entry)
		return entry.title:find("pull")
	end,
	f
}

generate{
	title = "My awesome feed",
	filename = "whatever.xml",
	baseUrl = "http://localhost/",
	f2,
}


--print(#(filtered.entries))
