-- Projectum Lunare Xmake Repository - anim8 Package
-- Category: Game Engines, Creative Coding & LÖVE
-- Animation library for LÖVE (Love2D)
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("anim8")
    set_homepage("https://github.com/kikito/anim8")
    set_description("Animation library for LÖVE (Love2D).")
    set_license("MIT")

    add_urls("https://github.com/kikito/anim8/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/kikito/anim8.git")

    add_versions("v2.3.1", "91a6daefc16b266b61a6c7b5002c3c0a223da60ccfd688e13af52aa755ea23ce")
    add_versions("v2.3.0", "8d62d4863d2df5b06df7e1ec854c84e898c3c25768223471a06ad07b0db4a846")
    add_versions("v2.2.0", "673559055f53de720f3412e65f1da0b1770640d87ce5439f19b7534ad4026fb0")
    add_versions("v2.1.0", "30259570e500ee0b250f1b3d3fa3b90c4fcfbdccd5d8cda1b618f2b7b2eb2f99")

    add_deps("lua")
    add_deps("forge master", {kind = "addon"})

    on_install(function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            includes("@addon/forge/forge.lua")

            target("anim8")
                add_rules("forge.lua.module")
                add_packages("lua")
                add_files("anim8.lua")
        ]])
        import("@addon.forge.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.forge.lua.module").lua_test(package, "local anim8 = require('anim8'); assert(anim8._VERSION:find('anim8'))")
    end)
