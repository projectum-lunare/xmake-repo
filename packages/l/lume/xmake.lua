-- Projectum Lunare Xmake Repository - lume Package
-- Category: Game Engines, Creative Coding & LÖVE
-- Collection of functions for Lua geared towards game development
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("lume")
    set_homepage("https://github.com/rxi/lume")
    set_description("A collection of functions for Lua, geared towards game development.")
    set_license("MIT")

    add_urls("https://github.com/rxi/lume/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/rxi/lume.git")

    add_versions("v2.3.0", "e74dfa2feeb639f0d26a8014ab5e0344f3c457e029719e659710896be8636461")
    add_versions("v2.2.3", "5b4604596606e6f5a1d4d1285f658d0fca4c15873688a6ce22276a1234551369")
    add_versions("v2.2.2", "70dc99fae7fc703b4d403a7a8928834820fbc5fb83f7e33debc5c6c39bfdfc56")

    add_deps("lua")
    add_deps("forge master", {kind = "addon"})

    on_install(function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            includes("@addon/forge/forge.lua")

            target("lume")
                add_rules("forge.lua.module")
                add_packages("lua")
                add_files("lume.lua")
        ]])
        import("@addon.forge.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.forge.lua.module").lua_test(package, "local lume = require('lume'); assert(lume.clamp(5, 1, 10) == 5)")
    end)
