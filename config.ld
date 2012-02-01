project = "lua-feedfilter"
description = [[Wreak havoc with RSS/Atom feeds and make a frankenfeed of your own.

Loading the feedfilter.configdsl module creates a number of global
functions intended to specify a domain-specific language for feed
aggregation, filtering, transformation, and re-generation. The command
`lua-feedfilter` takes `config.lua`, or any other file name(s) if
specified on the command line, and processes them individually in an
environment containing these functions.
]]

--readme = "readme.mkd"
file = "feedfilter/configdsl.lua"
examples = { "config.lua" }
no_return_or_parms = true
no_summary = true
format = "markdown"
