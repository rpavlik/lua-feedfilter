#!/usr/bin/env lua -lluarocks.loader
require "std"
local http = require "socket.http"

require "feedfilter.configdsl"

local f = feed{
	url = "https://github.com/rpavlik.atom",
	name = "Ryan's GitHub activity"
}

local results = f:get()
print(results)
