

local mergeFeeds = function(args)
	local newFeed = {--[[
		id = args.id,
		title = args.title,
	]]
		entries = {}
	}
	for k, v in pairs(args) do
		if type(k) ~= "number" or k > #args or k < 1 then
			newFeed[k] = v
		end
	end
	local newEntries = {}
	for _, feed in ipairs(args) do
		for _, entry in ipairs(feed.entries) do
			table.insert(newFeed.entries, entry)
		end
	end
	table.sort(newFeed.entries, function (a, b) return a.updated_parsed < b.updated_parsed end)
	local newest = newFeed.entries[#(newFeed.entries)]
	newFeed.updated = newest.updated
	return newFeed
end

require "cosmo"

local atomTemplate = [=[
<?xml version="1.0" encoding="utf-8"?>
 
<feed xmlns="http://www.w3.org/2005/Atom">
	<title>$title</title>
    <id>%id</id>
    <updated>$updated</updated>
    <!--
    <author>
        <name>John Doe</name>
        <email>johndoe@example.com</email>
    </author>
    -->
$entries[[
    <entry>
        <title>$title</title>
        <link href="$link" />
        <id>$id</id>
        <updated>$updated</updated>
        <summary>$summary</summary>
    </entry>
]]
 
</feed>

]=]

local generateFeed = function(newFeed)
	return cosmo.fill(atomTemplate, newFeed)
end

return {
	["generateFeed"] = generateFeed,
	["mergeFeeds"] = mergeFeeds
}
