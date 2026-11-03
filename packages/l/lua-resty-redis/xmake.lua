-- Projectum Lunare Xmake Repository - lua-resty-redis Package
-- Category: OpenResty & NGINX Ecosystem
-- Lua Redis client driver for ngx_lua based on the cosocket API
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("lua-resty-redis")
    set_homepage("https://github.com/openresty/lua-resty-redis")
    set_description("Lua Redis client driver for ngx_lua based on the cosocket API.")
    set_license("BSD-2-Clause")

    add_urls("https://github.com/openresty/lua-resty-redis/archive/refs/tags/v$(version).tar.gz")
    add_urls("https://github.com/openresty/lua-resty-redis.git")

    add_versions("0.34", "427fde15a4ad2237c947368bee2c443bf8f402e339f64bf3716de324c6afb613")
    add_versions("0.33", "d044661400811fc77d386bb0b1fd9e82bf7fbb97112bc8a2650b059883307d96")
    add_versions("0.32", "15a18b82bec18e8a3ecfb355b2f1288e375a3e9a5ce8d7c52cf1a335b8b735ec")

    add_deps("lua")
    add_deps("recudo master", {kind = "addon"})

    on_install(function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            includes("@addon/recudo/recudo.lua")

            target("lua-resty-redis")
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
            _G.ngx = setmetatable({}, mt)
            package.preload["table.clear"] = function()
                return function(t) for k in pairs(t) do t[k] = nil end end
            end
            local redis = require("resty.redis")
            assert(redis.new)
        ]])
    end)
