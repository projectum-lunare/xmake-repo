-- Projectum Lunare Xmake Repository - lua-tablepool Package
-- Category: OpenResty & NGINX Ecosystem
-- Lua table recycling pools for LuaJIT and OpenResty
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("lua-tablepool")
    set_homepage("https://github.com/openresty/lua-tablepool")
    set_description("Lua table recycling pools for LuaJIT and OpenResty.")
    set_license("BSD-2-Clause")

    add_urls("https://github.com/openresty/lua-tablepool/archive/refs/tags/v$(version).tar.gz")
    add_urls("https://github.com/openresty/lua-tablepool.git")

    add_versions("0.03", "dc91545505883d20d02a221d22b37b70faf044d09ba9397e83ec4afd8805aece")
    add_versions("0.02", "b0a525219bc54445b993b3e9b7bc0c59ec45d33f70c413e3cb5b0f0a209e2221")
    add_versions("0.01", "0b0c90f71526ce7ba94a3cd362d065279ce370fcf8b251a7062c181fd79be496")


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

            target("lua-tablepool")
                add_rules("recudo.lua.module")
                add_packages("lua")
                add_files("lib/**.lua")
        ]])
        import("@addon.recudo.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.recudo.lua.module").lua_test(package, [[
            package.preload["table.new"] = function()
                return function(narr, nrec) return {} end
            end
            package.preload["table.clear"] = function()
                return function(t) for k in pairs(t) do t[k] = nil end end
            end
            local tablepool = require("tablepool")
            assert(tablepool.fetch)
            assert(tablepool.release)
            local t = tablepool.fetch("test", 0, 1)
            assert(type(t) == "table")
            tablepool.release("test", t)
        ]])
    end)
