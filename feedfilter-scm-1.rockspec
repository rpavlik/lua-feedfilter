package = "feedfilter"
version = "scm-1"
source = {
   url = "http://..." -- We don't have one yet
}
description = {
   summary = "Lua feed aggregator and filter.",
   detailed = [[ TODO ]],
   homepage = "http://...", -- We don't have one yet
--   license = "MIT/X11" -- or whatever you like
}
dependencies = {
   "lua >= 5.1",
   "luasocket",
   "luasec",
  -- "mk"
}

build = {
  type = "builtin",
  modules = {
    ["feedfilter.configdsl"] = "feedfilter/configdsl.lua",
    ["feedfilter.feed"] = "feedfilter/feed.lua",
    ["feedfilter.https"] = "feedfilter/https.lua",
    ["feedparser"] = "lua-feedparser/feedparser.lua",
    ["feedparser.dateparser"] = "lua-feedparser/feedparser/dateparser.lua",
    ["feedparser.url"] = "lua-feedparser/feedparser/url.lua",
    ["feedparser.XMLElement"] = "lua-feedparser/feedparser/XMLElement.lua",
  },
  copy_directories = { --[["samples", "doc", "tests" ]]},
}
