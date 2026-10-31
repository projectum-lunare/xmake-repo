-- Projectum Lunare Xmake Repository - middleclass Package
-- Object orientation for Lua
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("middleclass")
    set_homepage("https://github.com/kikito/middleclass")
    set_description("Object orientation for Lua.")
    set_license("MIT")

    add_urls("https://github.com/kikito/middleclass/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/kikito/middleclass.git")

    add_versions("v4.1.1", "d01e5af2a61eeb8c9533f8b3b0fa665bd8ad693c2b9fb297b20e3f9e16d85085")
    add_versions("v4.1.0", "8f518374bbbe1cd58ce347c89ad15b6797892cac2b4d28df824990ad6b18d102")

    add_deps("lua")
    add_deps("forge master", {kind = "addon"})

    on_install(function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            includes("@addon/forge/forge.lua")

            target("middleclass")
                add_rules("forge.lua.module")
                add_files("middleclass.lua")
        ]])
        import("@addon.forge.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.forge.lua.module").lua_test(package, "local class = require('middleclass'); local A = class('A'); assert(A:new())")
    end)
