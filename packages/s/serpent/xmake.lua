-- Projectum Lunare Xmake Repository - serpent Package
-- Category: Parsing, Data Formats & Templates
-- Lua serializer and pretty printer
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("serpent")
    set_homepage("https://github.com/pkulchenko/serpent")
    set_description("Lua serializer and pretty printer.")
    set_license("MIT")

    add_urls("https://github.com/pkulchenko/serpent/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/pkulchenko/serpent.git")

    add_versions("0.30", "ebc8d9121a793ae2df69ca03b7f9d2ad0e82e385d4ed0d452eedd305c1b93b22")
    add_versions("0.28", "93c35fc1941d300268ba2d4eca4a80a8c9965c789e1150678d7d68158e1f2fef")

    add_deps("lua")
    add_deps("forge master", {kind = "addon"})

    on_install(function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            includes("@addon/forge/forge.lua")

            target("serpent")
                add_rules("forge.lua.module")
                add_files("src/serpent.lua")
        ]])
        import("@addon.forge.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.forge.lua.module").lua_test(package, "local serpent = require('serpent'); assert(serpent.dump({a = 1}))")
    end)
