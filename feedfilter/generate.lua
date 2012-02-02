

local mergeFeeds = function(feedData, feeds)
	local newFeed = {--[[
		id = args.id,
		title = args.title,
	]]
		entries = {}
	}
	for k, v in pairs(feedData) do
		if type(k) ~= "number" or k > #args or k < 1 then
			newFeed[k] = v
		end
	end
	for _, feed in ipairs(feeds) do
		local feedData = feed:get()
		for _, entry in ipairs(feedData.entries) do
			if type(entry.updated_parsed) ~= "number" then
				print("WARNING: Skipping entry with invalid updated_parsed field:", entry.updated_parsed, "in feed", feedData.url)
			else
				table.insert(newFeed.entries, entry)
			end
		end
	end
	table.sort(newFeed.entries, function (a, b) return a.updated_parsed > b.updated_parsed end)
	local newest = newFeed.entries[#(newFeed.entries)]
	newFeed.updated = newest.updated
	return newFeed
end

require "cosmo"

local atomTemplate = [[
<?xml version="1.0" encoding="utf-8"?>
 
<feed xmlns="http://www.w3.org/2005/Atom">
	<title>$xmlencode{$title}</title>
    <id>$xmlencode{$id}</id>
    <updated>$updated</updated>
    $if{ $author }[=[
    <author>
        <name>$xmlencode{$author|name}</name>
        <email>$xmlencode{$author|email}</email>
    </author>
    ]=]
$entries[=[
    <entry>
        <title>$xmlencode{$title}</title>
        <link href="$xmlencode{$link}" />
        <id>$xmlencode{$id}</id>
        <updated>$xmlencode{$updated}</updated>
        $if{$summary}[==[<summary>$xmlencode{$summary}</summary>]==]
        $if{$content}[==[$if{$contentHTML}[===[<content type="html">]===],[===[<content>]===]$xmlencode{$content}</content>]==]
    </entry>
]=]
 
</feed>

]]


local generateFeed = function(newFeed)
	require "LuaXml"
	local optionallyEncode = function(val)
		if val[1] ~= nil and val[1] ~= "nil" then
			return xml.encode(val[1])
		end
	end
	local myInput = setmetatable({["if"] = cosmo.cif, ["xmlencode"] = optionallyEncode}, {__index=newFeed})
	return cosmo.fill(atomTemplate, myInput)
end

return {
	["generateFeed"] = generateFeed,
	["mergeFeeds"] = mergeFeeds
}
