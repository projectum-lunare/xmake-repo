-- Projectum Lunare Xmake Repository - lua-resty-string Package
-- Category: OpenResty & NGINX Ecosystem
-- String utilities and common hashes for OpenResty
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("lua-resty-string")
    set_homepage("https://github.com/openresty/lua-resty-string")
    set_description("String utilities and common hashes for OpenResty.")
    set_license("BSD-2-Clause")

    add_urls("https://github.com/openresty/lua-resty-string/archive/refs/tags/v$(version).tar.gz")
    add_urls("https://github.com/openresty/lua-resty-string.git")

    add_versions("0.19", "8b3e17e8796f083228b89ddd013bcc688c7d15afcc721c70059fd4a8bf2355dc")
    add_versions("0.18", "9c554732ea7624eef9e8f6cc2c2b26e10261b8ebe46ffc7565b7ade3154a64dd")
    add_versions("0.17", "edf5c5c61956474888c374de26830e8b6c1ef83ff40e1c643f8566192649ada8")

    add_deps("lua")
    add_deps("recudo master", {kind = "addon"})

    on_install(function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            includes("@addon/recudo/recudo.lua")

            target("lua-resty-string")
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
            _G.ngx = setmetatable({}, mt)
            package.preload["ffi"] = function()
                return {
                    new = function() return nil end,
                    string = function() return "" end,
                    typeof = function() return nil end,
                    cdef = function() end,
                    C = {}
                }
            end
            local str = require("resty.string")
            assert(str)
        ]])
    end)
