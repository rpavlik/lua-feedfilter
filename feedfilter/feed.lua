
require "feedparser"
local verbose = require "feedfilter.verbose"

local feednum = 1

local feedproto = {}

feedproto.frequency = 60

local createDummyFeed = function(self)
	return setmetatable({ feed = {}, entries = {} }, {__index = self})
end

feedproto.get = function(self)
	if self.cachedBody == nil then
		assert(self.url ~= nil, "URL must be provided!")
		verbose(("Retrieving feed number %d"):format(self.feednum))
		local https = require("feedfilter.https")
		local b, c, h = https.request(self.url)
		if type(c) ~= "number" or c < 200 or c > 299 then
			print(("ERROR: Skipping feed %s due to failure during request - code '"):format(self.url) .. c .. "'")
			return createDummyFeed(self)
		end
		self.cachedBody = b
	end
	local parsed, err = feedparser.parse(self.cachedBody)
	if type(parsed) ~= "table" then
		print("ERROR: Could not parse response from", self.url, err)
		return createDummyFeed(self)
	end

	return setmetatable(parsed, {__index = self})
end

local feedmt = { __index = feedproto }

return function(self)
	self.feednum = feednum
	feednum = feednum + 1
	verbose( ("Constructing feed number %d"):format(self.feednum))
	return setmetatable(self, feedmt)
end
