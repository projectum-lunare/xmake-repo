-- Projectum Lunare Xmake Repository - lua-resty-limit-traffic Package
-- Category: OpenResty & NGINX Ecosystem
-- Lua library to limit and traffic shape in OpenResty/ngx_lua
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("lua-resty-limit-traffic")
    set_homepage("https://github.com/openresty/lua-resty-limit-traffic")
    set_description("Lua library to limit and traffic shape in OpenResty/ngx_lua.")
    set_license("BSD-2-Clause")

    add_urls("https://github.com/openresty/lua-resty-limit-traffic/archive/refs/tags/v$(version).tar.gz")
    add_urls("https://github.com/openresty/lua-resty-limit-traffic.git")

    add_versions("0.09", "547ee6942939928407781dc938723f81c2a619d492f514826e38544f5791bbca")
    add_versions("0.08", "33020df8db0edb621e51996e2d7a3459a86fc2bb353e6f0062c2bbd860b603d2")
    add_versions("0.07", "90b88114a8bed6e23dfb8c82a3ea5e96bbf8c7fb7ca0612fe49c6035099d0a79")

    add_deps("lua")
    add_deps("forge master", {kind = "addon"})

    on_install(function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            includes("@addon/forge/forge.lua")

            target("lua-resty-limit-traffic")
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
                    sizeof = function() return 8 end,
                    cdef = function() end,
                    C = {}
                }
            end
            local limit_conn = require("resty.limit.conn")
            assert(limit_conn.new)
            local limit_count = require("resty.limit.count")
            assert(limit_count.new)
            local limit_req = require("resty.limit.req")
            assert(limit_req.new)
            local limit_traffic = require("resty.limit.traffic")
            assert(limit_traffic.combine)
        ]])
    end)
