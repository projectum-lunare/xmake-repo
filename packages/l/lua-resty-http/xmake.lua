-- Projectum Lunare Xmake Repository - lua-resty-http Package
-- Lua HTTP client cosocket driver for OpenResty / ngx_lua
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("lua-resty-http")
    set_homepage("https://github.com/ledgetech/lua-resty-http")
    set_description("Lua HTTP client cosocket driver for OpenResty / ngx_lua.")
    set_license("BSD-2-Clause")

    add_urls("https://github.com/ledgetech/lua-resty-http/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/ledgetech/lua-resty-http.git")

    add_versions("v0.18.0", "d84e87bfea7bc1b91c52a27c9464d1412823ce748fd13d3885308f21166f946b")
    add_versions("v0.17.2", "3da18ca8582243eff28302591e36651dc7fab046e77336aa4a6fa718bccce4a2")

    add_deps("lua")
    add_deps("forge master", {kind = "addon"})

    on_install(function (package)
        io.replace("lib/resty/http.lua", "for key, values in pairs(headers) do\n        key = tostring(key)", "for raw_key, values in pairs(headers) do\n        local key = tostring(raw_key)", {plain = true})

        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            includes("@addon/forge/forge.lua")

            target("lua-resty-http")
                add_rules("forge.lua.module")
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
            _G.ngx = setmetatable({ config = { ngx_lua_version = "0" } }, mt)
            package.preload["ffi"] = function() return setmetatable({}, mt) end
            package.preload["resty.string"] = function() return setmetatable({}, mt) end
            local http = require("resty.http")
            assert(http.new)
        ]])
    end)
