#!/usr/bin/env lua

require "luarocks.loader"

require "feedfilter.configdsl"

if arg[1] == nil then
	arg[1] = "config.lua"
end

for i, fn in ipairs(arg) do
	print( ("Processing config file #%d: %s"):format(i, fn))
	dofile(fn)
end
