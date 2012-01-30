
-- fall back to values of the source.
local filterproto = setmetatable({}, {__index = function(self, key) return self.source[key] end})

-- Create a wrapper for "get"
filterproto.get = function(self)
	assert(self.predicate ~= nil, "predicate must be non-nil for a filter")
	local origResults = self.source:get()
	local results = {}
	for k, v in pairs(origResults) do
		if k == "entries" then
			results.entries = {}
			for _, entry in ipairs(v) do
				if self.predicate(entry) then
					table.insert(results.entries, entry)
				end
			end
		else
			results[k] = v
		end
	end
	return results
end

local filtermt = { __index = filterproto }

return function(self)	
	assert(self.source ~= nil, "source must be non-nil for a filter")
	return setmetatable(self, filtermt)
end
