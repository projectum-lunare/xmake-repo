-- Projectum Lunare Xmake Repository - lua-resty-websocket Package
-- Category: OpenResty & NGINX Ecosystem
-- Lua WebSocket implementation for the ngx_lua module in OpenResty
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("lua-resty-websocket")
    set_homepage("https://github.com/openresty/lua-resty-websocket")
    set_description("Lua WebSocket implementation for the ngx_lua module in OpenResty.")
    set_license("BSD-2-Clause")

    add_urls("https://github.com/openresty/lua-resty-websocket/archive/refs/tags/v$(version).tar.gz")
    add_urls("https://github.com/openresty/lua-resty-websocket.git")

    add_versions("0.16", "13a51c8584147b922a7583d8b01281fc5f16b0295419ccd49b1ddb15437677df")
    add_versions("0.15", "4339974c2143f74dc53dcbc46ae26a567c47daf0a90134c7ad29190e5bc6e401")
    add_versions("0.14", "273e205a6b058c0606aeb6999cfe6ac8693c5cf492df09ffce244911e6c0e1dd")


    on_load(function (package)
        import("@addon.recudo.lua.runtime").setup(package, {
            runtime = {"luajit", "openresty-luajit"},
            default = "luajit",
        })
    end)


    on_install(function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            includes("@addon/recudo/recudo.lua")

            target("lua-resty-websocket")
                add_rules("recudo.lua.module")
                add_packages("lua")
                add_files("lib/resty/**.lua")
        ]])
        import("@addon.recudo.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.recudo.lua.module").lua_test(package, [[
            local mt = {}
            mt.__index = function(t, k)
                t[k] = setmetatable({}, mt)
                return t[k]
            end
            _G.ngx = setmetatable({
                config = {
                    subsystem = "http",
                    ngx_lua_version = 10028,
                }
            }, mt)
            package.preload["ffi"] = function()
                return {
                    new = function() return nil end,
                    string = function() return "" end,
                    typeof = function() return nil end,
                    cdef = function() end,
                    C = {}
                }
            end
            package.preload["bit"] = function()
                return {
                    band = function(a, b) return a & b end,
                    bxor = function(a, b) return a ~ b end,
                    bor = function(a, b) return a | b end,
                    lshift = function(a, b) return a << b end,
                    rshift = function(a, b) return a >> b end,
                    tohex = function(n) return string.format("%x", n) end
                }
            end
            local server = require("resty.websocket.server")
            assert(server.new)
            local client = require("resty.websocket.client")
            assert(client.new)
        ]])
    end)
