-- Projectum Lunare Xmake Repository - date Package
-- Category: Data Structures, Concurrency & Utilities
-- Date & Time module for Lua 5.x
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("date")
    set_homepage("https://github.com/Tieske/date")
    set_description("Date & Time module for Lua 5.x.")
    set_license("MIT")

    add_urls("https://github.com/Tieske/date/archive/refs/tags/version_$(version).tar.gz")
    add_urls("https://github.com/Tieske/date.git")

    add_versions("2.2.1", "2c6a21fbc30191c94a40549cb8dda2623c3a4457ae92370b0e6be827ea6845b0")
    add_versions("2.2", "ea8c34cb18245c5219806a00c97ef92f452a33f3528bac2ae72743e4420897db")

    add_deps("lua")
    add_deps("recudo master", {kind = "addon"})

    on_install(function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            includes("@addon/recudo/recudo.lua")

            target("date")
                add_rules("recudo.lua.module")
                add_files("src/date.lua")
        ]])
        import("@addon.recudo.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.recudo.lua.module").lua_test(package, "local date = require('date'); local d = date('2026-10-31'); assert(d:getyear() == 2026)")
    end)
