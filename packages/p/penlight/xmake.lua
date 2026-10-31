-- Projectum Lunare Xmake Repository - Penlight Package
-- Category: Data Structures, Concurrency & Utilities
-- Lua utility libraries loosely based on the Python standard libraries
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("penlight")
    set_homepage("https://github.com/lunarmodules/Penlight")
    set_description("Lua utility libraries loosely based on the Python standard libraries.")
    set_license("MIT")

    add_urls("https://github.com/lunarmodules/Penlight/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/lunarmodules/Penlight.git")

    add_versions("1.15.0", "b7a2c3e65799a649d29e9927a337f99cca2a5fc46367a0ce101435be74e53b39")
    add_versions("1.14.0", "2387431c0e83c4189cccb35b989141a3280d735cb5d42bacf3451af9869bebf7")
    add_versions("1.13.1", "530380e1a377df519c2e589f47823f79701f8e0e67f6bbd994e18d09a470b680")

    add_deps("lua")
    if is_plat("windows", "mingw", "linux", "macosx", "bsd", "haiku") then
        add_deps("luafilesystem", {configs = {shared = true}})
    else
        add_deps("luafilesystem")
    end
    add_deps("forge master", {kind = "addon"})

    on_install(function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            includes("@addon/forge/forge.lua")

            target("pl")
                add_rules("forge.lua.module")
                add_packages("lua")
                add_files("lua/pl/**.lua")
        ]])
        import("@addon.forge.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.forge.lua.module").lua_test(package, [[
            local pl = require("pl")
            local List = require("pl.List")
            local l = List({10, 20, 30})
            assert(l:reduce("+") == 60)
            local path = require("pl.path")
            assert(path.extension("test.lua") == ".lua")
        ]])
    end)
