-- Based on mailing list code
-- http://lua-users.org/lists/lua-l/2009-02/msg00270.html
-- Modified to add a wrapped version of http.request


local socket = require "socket"
local ssl = require "ssl"

local params = {
    mode = "client",
    protocol = "tlsv1",
    cafile = "/etc/ssl/certs/ca-certificates.crt",
    verify = "peer",
    options = "all",
}

local try = socket.try
local protect = socket.protect

local function create()
    local t = {c=try(socket.tcp())}

    function idx (tbl, key)
        --print("idx " .. key)
        return function (prxy, ...)
                   local c = prxy.c
                   return c[key](c,...)
               end
    end


    function t:connect(host, port)
        --print ("proxy connect ", host, port)
        try(self.c:connect(host, port))
        --print ("connected")
        self.c = try(ssl.wrap(self.c,params))
        --print("wrapped")
        try(self.c:dohandshake())
        --print("handshaked")
        return 1
    end

    return setmetatable(t, {__index = idx})
end

local function handleAdvancedRequest(request)
    local socketurl = require "socket.url"
    local http = require "socket.http"
    local parsed = socketurl.parse(request.url)
    request.create = create
    if parsed.port == nil then
        parsed.port = 443
    end
    request.url = socketurl.build(parsed)
    return http.request(request)
end

local function wrapped_request(arg1, arg2)
    local socketurl = require("socket.url")
    local parsed = socketurl.parse(a)
    if type(arg1) == "table" and socketurl.parse(arg1.url).scheme == "https" then
     return handleAdvancedRequest(arg1)
    end
    if socketurl.parse(arg1).scheme ~= "https" then
        local http = require "socket.http"
        return http.request(arg1, arg2)
    end

    local ltn12 = require('ltn12')
    local result_table = {}
    local request = {
        url = arg1,
        sink = ltn12.sink.table(result_table)
    }
    if arg2 ~= nil then
        request.headers = { ['content-type']='text/plain', ['content-length']=arg2:len() }
        request.source = ltn12.source.string(arg2)
    end
    local b, c, h = handleAdvancedRequest(request)
    return table.concat(result_table), c, h)
end

return { ["create"] = create, ["request"] = wrapped_request }
