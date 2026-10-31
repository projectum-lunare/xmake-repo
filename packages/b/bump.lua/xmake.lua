-- Projectum Lunare Xmake Repository - bump.lua Package
-- Category: Game Engines, Creative Coding & LÖVE
-- Lua collision-detection library for axis-aligned rectangles (AABB)
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("bump.lua")
    set_homepage("https://github.com/kikito/bump.lua")
    set_description("Lua collision-detection library for axis-aligned rectangles (AABB).")
    set_license("MIT")

    add_urls("https://github.com/kikito/bump.lua/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/kikito/bump.lua.git")

    add_versions("v3.1.7", "c89623fafae5b308360922db839d2613cf296e55ac59c47ae458c386cf1eea80")
    add_versions("v3.1.6", "b706bb47c046b7abcb9b20ec2930301332a5ad9400e3717cff0f7be6d2091f6b")
    add_versions("v3.1.5", "62735059a8c05181543dc2f7dc23b971800f8047eef3a0532dfc60a99f723dd2")

    add_deps("lua")
    add_deps("forge master", {kind = "addon"})

    on_install(function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            includes("@addon/forge/forge.lua")

            target("bump")
                add_rules("forge.lua.module")
                add_packages("lua")
                add_files("bump.lua")
        ]])
        import("@addon.forge.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.forge.lua.module").lua_test(package, "local bump = require('bump'); local world = bump.newWorld(); assert(world)")
    end)
