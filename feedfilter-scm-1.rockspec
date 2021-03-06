package = "feedfilter"
version = "scm-1"
source = {
   url = "git://github.com/rpavlik/lua-feedfilter.git"
}
description = {
   summary = "Lua feed aggregator and filter.",
   detailed = [[ TODO ]],
   homepage = "https://github.com/rpavlik/lua-feedfilter",
--   license = "MIT/X11" -- or whatever you like
}
dependencies = {
   "lua >= 5.1",
   "luasocket",
   "luasec",
   "feedparser",
   "cosmo",
   "luaxml"
  -- "mk"
}

build = {
  type = "builtin",
  modules = {
    ["feedfilter.configdsl"] = "feedfilter/configdsl.lua",
    ["feedfilter.feed"] = "feedfilter/feed.lua",
    ["feedfilter.filter"] = "feedfilter/filter.lua",
    ["feedfilter.generate"] = "feedfilter/generate.lua",
    ["feedfilter.https"] = "feedfilter/https.lua",
    ["feedfilter.verbose"] = "feedfilter/verbose.lua",
  },
  install = {
    bin = {
      "lua-feedfilter"
    }
  },
  copy_directories = { --[["samples", "doc", "tests" ]]},
}
