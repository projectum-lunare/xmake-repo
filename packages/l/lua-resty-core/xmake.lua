-- Projectum Lunare Xmake Repository - lua-resty-core Package
-- Category: OpenResty & NGINX Ecosystem
-- New FFI-based API for lua-nginx-module
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("lua-resty-core")
    set_homepage("https://github.com/openresty/lua-resty-core")
    set_description("New FFI-based API for lua-nginx-module.")
    set_license("BSD-2-Clause")

    add_urls("https://github.com/openresty/lua-resty-core/archive/refs/tags/v$(version).tar.gz")
    add_urls("https://github.com/openresty/lua-resty-core.git")

    add_versions("0.1.31", "a8af7beadd43dd4758b7dc3c00e027dd3908e73f5bf0e08155a2c8954c5937c0")
    add_versions("0.1.30", "adc7781ddaeab9341b82033a6c06b0d190d4c6d1c2dddd46f6965ce9e57a0310")
    add_versions("0.1.29", "e416241724ce36ae90dddae8652f8c451e1ad87ebfb3cd62de76985492ef315f")

    add_deps("lua-resty-lrucache")

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

            target("lua-resty-core")
                add_rules("recudo.lua.module")
                add_packages("lua")
                add_files("lib/**.lua")
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
                    cdef = function() end,
                    C = {}
                }
            end
            local base = require("resty.core.base")
            assert(base)
        ]])
    end)
