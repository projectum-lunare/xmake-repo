-- Projectum Lunare Xmake Repository - lua-resty-http2 Package
-- Category: OpenResty & NGINX Ecosystem
-- HTTP/2 protocol implementation for OpenResty
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("lua-resty-http2")
    set_homepage("https://github.com/tokers/lua-resty-http2")
    set_description("HTTP/2 protocol implementation for OpenResty.")
    set_license("BSD-2-Clause")

    add_urls("https://github.com/tokers/lua-resty-http2/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/tokers/lua-resty-http2.git")

    add_versions("v1.0", "66901be9e976be734140ef5b3d3ce060fee65ceead9a56021afbdb9b785cf6af")


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

            target("lua-resty-http2")
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
                log = function(...) end,
                config = {
                    subsystem = "http",
                    ngx_lua_version = 10028,
                    debug = false,
                }
            }, mt)
            package.preload["bit"] = function()
                return {
                    band = function(a, b) return a & b end,
                    bxor = function(a, b) return a ~ b end,
                    bor = function(a, b) return a | b end,
                    bnot = function(a) return ~a end,
                    lshift = function(a, b) return a << b end,
                    rshift = function(a, b) return a >> b end,
                    tohex = function(n) return string.format("%x", n) end
                }
            end
            local http2 = require("resty.http2")
            assert(http2.new)
        ]])
    end)
