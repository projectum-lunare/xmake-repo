-- Projectum Lunare Xmake Repository - lua-resty-jwt Package
-- Category: OpenResty & NGINX Ecosystem
-- JWT (JSON Web Tokens) for ngx_lua and LuaJIT
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("lua-resty-jwt")
    set_homepage("https://github.com/cdbattags/lua-resty-jwt")
    set_description("JWT (JSON Web Tokens) for ngx_lua and LuaJIT.")
    set_license("Apache-2.0")

    add_urls("https://github.com/cdbattags/lua-resty-jwt/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/cdbattags/lua-resty-jwt.git")

    add_versions("v0.4.0", "1a3ba164c8f62bebddc6d9a44630313ac39e9c8da503ce3ef7a6a4c3918a5a1c")
    add_versions("v0.3.2", "60fac658f17a6da7b8591c48bae596f62cdaff5c06ae8b56d24866e2336379b7")


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

            target("lua-resty-jwt")
                add_rules("recudo.lua.module")
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
            mt.__call = function(t, ...) return nil end
            setmetatable(package.preload, {
                __index = function(t, k)
                    return function() return setmetatable({}, mt) end
                end
            })
            local jwt = require("resty.jwt")
            assert(jwt.sign)
        ]])
    end)
