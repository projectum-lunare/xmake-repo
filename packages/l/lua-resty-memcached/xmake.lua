-- Projectum Lunare Xmake Repository - lua-resty-memcached Package
-- Category: OpenResty & NGINX Ecosystem
-- Lua memcached client driver for ngx_lua based on the cosocket API
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("lua-resty-memcached")
    set_homepage("https://github.com/openresty/lua-resty-memcached")
    set_description("Lua memcached client driver for the ngx_lua based on the cosocket API.")
    set_license("BSD-2-Clause")

    add_urls("https://github.com/openresty/lua-resty-memcached/archive/refs/tags/v$(version).tar.gz")
    add_urls("https://github.com/openresty/lua-resty-memcached.git")

    add_versions("0.18", "3567144cfa26e63453960ec347137f47403b264af071385d2f16b8434eb3736e")
    add_versions("0.17", "02733575c4aed15f6cab662378e4b071c0a4a4d07940c4ef19a7319e9be943d4")
    add_versions("0.16", "42893da0e3de4ec180c9bf02f82608d78787290a70c5644b538f29d243147396")

    add_deps("lua")
    add_deps("forge master", {kind = "addon"})

    on_install(function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            includes("@addon/forge/forge.lua")

            target("lua-resty-memcached")
                add_rules("forge.lua.module")
                add_packages("lua")
                add_files("lib/resty/**.lua")
        ]])
        import("@addon.forge.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.forge.lua.module").lua_test(package, [[
            local mt = {}
            mt.__index = function(t, k)
                t[k] = setmetatable({}, mt)
                return t[k]
            end
            _G.ngx = setmetatable({}, mt)
            package.preload["table.new"] = function()
                return function(narr, nrec) return {} end
            end
            package.preload["table.clear"] = function()
                return function(t) for k in pairs(t) do t[k] = nil end end
            end
            local memcached = require("resty.memcached")
            assert(memcached.new)
        ]])
    end)
