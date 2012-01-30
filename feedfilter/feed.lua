
require "lua-feedparser.feedparser"
local verbose = require "feedfilter.verbose"

local feedproto = {}

feedproto.frequency = 60
feedproto.get = function(self)
	if self.cachedBody == nil then
		assert(self.url ~= nil, "URL must be provided!")
		verbose("Retrieving", self.url)
		local https = require("feedfilter.https")
		local b, c, h = https.request(self.url)
		if c < 200 or c > 299 then
			error(("Failed getting %s - code %d"):format(self.url, c))
		end
		self.cachedBody = b
	end
	return feedparser.parse(self.cachedBody)
end

local feedmt = { __index = feedproto }

return function(self)
	verbose( ("Constructing feed %s"):format(self.url))
	return setmetatable(self, feedmt)
end
