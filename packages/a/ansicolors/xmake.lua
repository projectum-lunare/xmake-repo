-- Projectum Lunare Xmake Repository - ansicolors Package
-- Category: CLI, Terminal & Text UI
-- ANSI terminal color manipulation for Lua
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("ansicolors")
    set_homepage("https://github.com/kikito/ansicolors.lua")
    set_description("ANSI terminal color manipulation for Lua.")
    set_license("MIT")

    add_urls("https://github.com/kikito/ansicolors.lua/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/kikito/ansicolors.lua.git")

    add_versions("v1.0.2", "fa76a465c2e0d342f6d5a1d44c63bd398053f206f41c7b5356b551694f899d64")

    add_deps("lua")
    add_deps("forge master", {kind = "addon"})

    on_install(function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            includes("@addon/forge/forge.lua")

            target("ansicolors")
                add_rules("forge.lua.module")
                add_files("ansicolors.lua")
        ]])
        import("@addon.forge.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.forge.lua.module").lua_test(package, "local colors = require('ansicolors'); assert(colors('%{red}hello') ~= nil)")
    end)
