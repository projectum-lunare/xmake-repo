-- Projectum Lunare Xmake Repository - tween Package
-- Category: Game Engines, Creative Coding & LÖVE
-- Small library to perform tweening in Lua with minimal interface and easing functions
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("tween")
    set_homepage("https://github.com/kikito/tween.lua")
    set_description("Small library to perform tweening in Lua with minimal interface and easing functions.")
    set_license("MIT")

    add_urls("https://github.com/kikito/tween.lua/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/kikito/tween.lua.git")

    add_versions("v2.1.1", "0966cd9fe62631373ba2ce908604763496e94624ffb14f1a48edc885b0ae82d5")
    add_versions("v2.1.0", "422a8e03ae731ec6295f93dea59ad420db31090cbb17b6823f23bbb5583cffb3")
    add_versions("v2.0.0", "f5ef5b8adc0bf2d356dd2298e01cb79766250e5395b43e4cd11e880930f2c00d")

    add_deps("lua")
    add_deps("forge master", {kind = "addon"})

    on_install(function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            includes("@addon/forge/forge.lua")

            target("tween")
                add_rules("forge.lua.module")
                add_packages("lua")
                add_files("tween.lua")
        ]])
        import("@addon.forge.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.forge.lua.module").lua_test(package, "local tween = require('tween'); assert(type(tween.new) == 'function')")
    end)
