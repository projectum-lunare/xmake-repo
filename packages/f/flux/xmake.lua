-- Projectum Lunare Xmake Repository - flux Package
-- Category: Game Engines, Creative Coding & LÖVE
-- Fast, lightweight tweening library for Lua
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("flux")
    set_homepage("https://github.com/rxi/flux")
    set_description("A fast, lightweight tweening library for Lua.")
    set_license("MIT")

    add_urls("https://github.com/rxi/flux/archive/$(version).tar.gz", {version = function (version)
        local v = tostring(version)
        if v == "0.1.0" or v == "0.1" then
            return "bb330231b87eabf84fbd68322f13a6320db30a41"
        end
        return v
    end})
    add_urls("https://github.com/rxi/flux.git")

    add_versions("0.1.0", "3ecc818f6ad5db474b9f1adcd76762601c341c10e3bdae96f9c0baa2671c2fb1")
    add_versions("master", "bb330231b87eabf84fbd68322f13a6320db30a41")

    add_deps("lua")
    add_deps("forge master", {kind = "addon"})

    on_install(function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            includes("@addon/forge/forge.lua")

            target("flux")
                add_rules("forge.lua.module")
                add_packages("lua")
                add_files("flux.lua")
        ]])
        import("@addon.forge.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.forge.lua.module").lua_test(package, "local flux = require('flux'); assert(type(flux.to) == 'function')")
    end)
