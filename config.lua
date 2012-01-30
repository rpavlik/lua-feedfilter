

generate{
	title = "My awesome feed",
	filename = "whatever.xml",
	baseUrl = "http://localhost/",
	
	
	map{
		-- Transform URLs from relative to absolute, and mark contents as being HTML
		mapfunc = function(entry, feed)
			entry.contentHTML = true
			entry.content:gsub([[href="/]], [[href="https://github.com/]])
			return entry
		end,
		
		feed{
			url = "https://github.com/rpavlik.atom",
			name = "Ryan's GitHub activity"
		},
	}

}

