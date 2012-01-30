
-- fall back to values of the source.
local filterproto = setmetatable({}, {__index = function(self, key) return self.source[key] end})

-- Create a wrapper for "get"


local createEntryIterativeApplicationConstructor = function(action)
	local proto = {}
	proto.get = function(self)
		if rawget(self, "cachedResults") ~= nil then
			return self.cachedResults
		end
		local origResults = self.source:get()
		local results = {}
		for k, v in pairs(origResults) do
			if k == "entries" then
				results.entries = {}
				for _, entry in ipairs(v) do
					action(self, results.entries, entry, origResults)
				end
			else
				results[k] = v
			end
		end
		self.cachedResults = results
		return results
	end
	local mt = { __index = proto }
	return function(self)
		assert(self.source, "source must be non-nil")
		return setmetatable(self, mt)
	end
end
					

local filtermt = { __index = filterproto }
     
local filterconstructor = createEntryIterativeApplicationConstructor(function(self, entries, entry, origResults)
	if self.predicate(entry) then
		table.insert(entries, entry)
	end
end)

local mapconstructor = createEntryIterativeApplicationConstructor(function(self, entries, entry, origResults)
	local result = self.mapfunc(entry, origResults)
	if result ~= nil then
		table.insert(entries, result)
	end
end)

return {
	["newMap"] = mapconstructor,
	["newFilter"] = filterconstructor
}
