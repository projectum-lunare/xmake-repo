-- Projectum Lunare Xmake Repository - lua-resty-mysql Package
-- Category: OpenResty & NGINX Ecosystem
-- Nonblocking Lua MySQL driver library for OpenResty
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("lua-resty-mysql")
    set_homepage("https://github.com/openresty/lua-resty-mysql")
    set_description("Nonblocking Lua MySQL driver library for OpenResty.")
    set_license("BSD-2-Clause")

    add_urls("https://github.com/openresty/lua-resty-mysql/archive/refs/tags/v$(version).tar.gz")
    add_urls("https://github.com/openresty/lua-resty-mysql.git")

    add_versions("0.31", "cf0fe45638c967c80e3b81bb95855bdfa5cbf9b20c1d64f89f20f66433faf607")
    add_versions("0.30", "8bae90ba71c1b94d52e3f97177119ecf55f9d239bed6a1c24c44abcd45990ed9")
    add_versions("0.29", "1a22548915608aa41ffe7c1f2203ae9a256b5e211b0f7f2b6f94489ce9216037")

    add_deps("lua")
    add_deps("lua-resty-string")
    add_deps("recudo master", {kind = "addon"})

    on_install(function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            includes("@addon/recudo/recudo.lua")

            target("lua-resty-mysql")
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
            package.preload["ffi"] = function()
                return {
                    new = function() return nil end,
                    string = function() return "" end,
                    typeof = function() return nil end,
                    cdef = function() end,
                    C = {}
                }
            end
            package.preload["bit"] = function()
                return {
                    band = function(a, b) return a & b end,
                    bxor = function(a, b) return a ~ b end,
                    bor = function(a, b) return a | b end,
                    lshift = function(a, b) return a << b end,
                    rshift = function(a, b) return a >> b end,
                    tohex = function(n) return string.format("%x", n) end
                }
            end
            local mysql = require("resty.mysql")
            assert(mysql.new)
        ]])
    end)
