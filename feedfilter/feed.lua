
require "feedparser"
local verbose = require "feedfilter.verbose"

local feednum = 1

local feedproto = {}

feedproto.frequency = 60
feedproto.get = function(self)
	if self.cachedBody == nil then
		assert(self.url ~= nil, "URL must be provided!")
		verbose(("Retrieving feed number %d"):format(self.feednum))
		local https = require("feedfilter.https")
		local b, c, h = https.request(self.url)
		if type(c) ~= "number" or c < 200 or c > 299 then
			print(("ERROR: Skipping feed %s due to failure during request - code '"):format(self.url) .. c .. "'")
			return setmetatable({ feed = {}, entries = {} }, {__index = self})
		end
		self.cachedBody = b
	end
	return setmetatable(feedparser.parse(self.cachedBody), {__index = self})
end

local feedmt = { __index = feedproto }

return function(self)
	self.feednum = feednum
	feednum = feednum + 1
	verbose( ("Constructing feed number %d"):format(self.feednum))
	return setmetatable(self, feedmt)
end
