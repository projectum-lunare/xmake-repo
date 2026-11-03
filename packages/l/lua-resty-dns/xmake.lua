-- Projectum Lunare Xmake Repository - lua-resty-dns Package
-- Category: OpenResty & NGINX Ecosystem
-- DNS resolver library for the OpenResty / ngx_lua cosocket API
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("lua-resty-dns")
    set_homepage("https://github.com/openresty/lua-resty-dns")
    set_description("DNS resolver library for the OpenResty / ngx_lua cosocket API.")
    set_license("BSD-2-Clause")

    add_urls("https://github.com/openresty/lua-resty-dns/archive/refs/tags/v$(version).tar.gz")
    add_urls("https://github.com/openresty/lua-resty-dns.git")

    add_versions("0.24", "06e08aec4290ee83b505a0b9fa66fa4e9fbe729ce505bc88f3dc2093789223f7")
    add_versions("0.23", "ecc80b91bfb4f795b8a80acfa69e1778288ef60649ddd87f30a9c4a57ac5da79")
    add_versions("0.22", "70e9a01eb32ccade0d5116a25bcffde0445b94ad35035ce06b94ccd260ad1bf0")


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

            target("lua-resty-dns")
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
            package.preload["bit"] = function()
                return {
                    band = function(a, b) return a & b end,
                    rshift = function(a, b) return a >> b end,
                    lshift = function(a, b) return a << b end
                }
            end
            local r = require("resty.dns.resolver")
            assert(r.new)
        ]])
    end)
