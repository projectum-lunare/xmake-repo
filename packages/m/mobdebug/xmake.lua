-- Projectum Lunare Xmake Repository - mobdebug Package
-- Category: Development, Debugging & Profiling
-- Remote debugger for Lua (ZeroBrane Studio debug engine)
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("mobdebug")
    set_homepage("https://github.com/pkulchenko/MobDebug")
    set_description("MobDebug is a remote debugger for the Lua programming language.")
    set_license("MIT")

    add_urls("https://github.com/pkulchenko/MobDebug/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/pkulchenko/MobDebug.git")

    add_versions("0.80", "48a5b4dabe165ad7236365fdd62716d9131702609d954bae80de07d973f67bba")

    on_load(function (package)
        import("@addon.recudo.lua.runtime").setup(package, {
            runtime = {"lua", "luajit"},
            default = "lua",
        })
        package:add("deps", "luasocket", {configs = {shared = true}})
    end)

    on_install(function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            includes("@addon/recudo/recudo.lua")

            target("mobdebug")
                add_rules("recudo.lua.module")
                add_packages("lua")
                add_files("src/mobdebug.lua")
        ]])
        import("@addon.recudo.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.recudo.lua.module").lua_test(package, [[
            local mobdebug = require("mobdebug")
            assert(type(mobdebug.start) == "function")
            assert(type(mobdebug.pause) == "function")
            assert(mobdebug._VERSION ~= nil)
        ]])
    end)
