
local f = feed{
	url = "https://github.com/rpavlik.atom",
	name = "Ryan's GitHub activity"
}

local results = f:get()
print(results.entries)
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
