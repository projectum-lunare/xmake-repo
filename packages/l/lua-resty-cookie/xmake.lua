-- Projectum Lunare Xmake Repository - lua-resty-cookie Package
-- Category: OpenResty & NGINX Ecosystem
-- HTTP cookie manipulation for OpenResty/ngx_lua
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("lua-resty-cookie")
    set_homepage("https://github.com/cloudflare/lua-resty-cookie")
    set_description("HTTP cookie manipulation for OpenResty/ngx_lua.")
    set_license("BSD-2-Clause")

    add_urls("https://github.com/cloudflare/lua-resty-cookie/archive/refs/tags/v$(version).tar.gz")
    add_urls("https://github.com/cloudflare/lua-resty-cookie.git")

    add_versions("0.1.0", "d81b33129c6fb5203b571fa4d8394823bf473d8872c0357a1d0f14420b1483bd")


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

            target("lua-resty-cookie")
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
            local cookie = require("resty.cookie")
            assert(cookie.new)
        ]])
    end)
