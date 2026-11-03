-- Projectum Lunare Xmake Repository - lua-resty-maxminddb Package
-- Category: OpenResty & NGINX Ecosystem
-- MaxMind GeoIP2 / GeoLite2 database reader library for OpenResty
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("lua-resty-maxminddb")
    set_homepage("https://github.com/anjia0532/lua-resty-maxminddb")
    set_description("MaxMind GeoIP2 / GeoLite2 database reader library for OpenResty.")
    set_license("Apache-2.0")

    add_urls("https://github.com/anjia0532/lua-resty-maxminddb/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/anjia0532/lua-resty-maxminddb.git")

    add_versions("v1.3.7", "54ff6249b3b27de6c3a82c62cdbcf408213979bc2b3922180fd16e0aafbc02b0")
    add_versions("v1.3.6", "4e10a1c168ac80de31ec1fc097a1c5b1875322ad70f0d539adbdc3f734e52d86")
    add_versions("v1.3.5", "731e3b019d25963f96a61f0bb4e3f5a4ae74bb2469e5e1482c6eaff3df42ffc3")


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

            target("lua-resty-maxminddb")
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
                    cast = function() return nil end,
                    gc = function(o, fn) return o end,
                    cdef = function() end,
                    load = function() return {} end,
                    C = {}
                }
            end
            package.preload["table.isarray"] = function()
                return function(t) return type(t) == "table" and (#t > 0 or next(t) == nil) end
            end
            package.preload["table.nkeys"] = function()
                return function(t)
                    local n = 0
                    for _ in pairs(t) do n = n + 1 end
                    return n
                end
            end
            local mmdb = require("resty.maxminddb")
            assert(mmdb.init)
            assert(mmdb.lookup)
        ]])
    end)
