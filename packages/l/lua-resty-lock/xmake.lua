-- Projectum Lunare Xmake Repository - lua-resty-lock Package
-- Category: OpenResty & NGINX Ecosystem
-- Simple nonblocking mutex locks for OpenResty
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("lua-resty-lock")
    set_homepage("https://github.com/openresty/lua-resty-lock")
    set_description("Simple nonblocking mutex locks for OpenResty.")
    set_license("BSD-2-Clause")

    add_urls("https://github.com/openresty/lua-resty-lock/archive/refs/tags/v$(version).tar.gz")
    add_urls("https://github.com/openresty/lua-resty-lock.git")

    add_versions("0.09", "b4ddcd47db347e9adf5c1e1491a6279a6ae2a3aff3155ef77ea0a65c998a69c1")
    add_versions("0.08", "2b4683f9abe73e18ca00345c65010c9056777970907a311d6e1699f753141de2")
    add_versions("0.07", "eaf84f58b43289c1c3e0442ada9ed40406357f203adc96e2091638080cb8d361")

    add_deps("lua")
    add_deps("lua-resty-core")
    add_deps("forge master", {kind = "addon"})

    on_install(function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            includes("@addon/forge/forge.lua")

            target("lua-resty-lock")
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
            mt.__call = function(t, ...) return nil end
            mt.__tostring = function(t) return "" end
            mt.__concat = function(a, b) return tostring(a) .. tostring(b) end
            _G.ngx = setmetatable({ config = { subsystem = "http", ngx_lua_version = 10028 } }, mt)
            _G.jit = { version = "LuaJIT 2.1.0", version_num = 20100 }
            _G.getfenv = _G.getfenv or function() return _G end
            package.preload["ffi"] = function()
                return {
                    new = function() return nil end,
                    string = function() return "" end,
                    typeof = function() return nil end,
                    metatype = function(ct, mt) return mt end,
                    cdef = function() end,
                    C = {}
                }
            end
            local lock = require("resty.lock")
            assert(lock.new)
        ]])
    end)
