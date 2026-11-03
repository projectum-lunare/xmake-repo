-- Projectum Lunare Xmake Repository - lua-resty-lrucache Package
-- Category: OpenResty & NGINX Ecosystem
-- Lua-land LRU Cache based on LuaJIT FFI
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("lua-resty-lrucache")
    set_homepage("https://github.com/openresty/lua-resty-lrucache")
    set_description("Lua-land LRU Cache based on LuaJIT FFI.")
    set_license("BSD-2-Clause")

    add_urls("https://github.com/openresty/lua-resty-lrucache/archive/refs/tags/v$(version).tar.gz")
    add_urls("https://github.com/openresty/lua-resty-lrucache.git")

    add_versions("0.15", "8cf1a22e0d5b8f35cb0b2e14c58fcb3aa505a8fb6e956817f0cdb1f06593f072")
    add_versions("0.14", "5a9f2e3a292dc9745f267082fc4d5b9bed5ab55f27ea5495986eb2965918e803")
    add_versions("0.13", "573184006b98ccee2594b0d134fa4d05e5d2afd5141cbad315051ccf7e9b6403")

    add_deps("lua")
    add_deps("recudo master", {kind = "addon"})

    on_install(function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            includes("@addon/recudo/recudo.lua")

            target("lua-resty-lrucache")
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
            mt.__call = function(t, ...) return nil end
            mt.__tostring = function(t) return "" end
            mt.__concat = function(a, b) return tostring(a) .. tostring(b) end
            _G.ngx = setmetatable({ now = function() return 0 end }, mt)
            _G.jit = { version = "LuaJIT 2.1.0" }
            package.preload["ffi"] = function() return setmetatable({}, mt) end
            local lrucache = require("resty.lrucache")
            assert(lrucache.new)
        ]])
    end)
