-- Projectum Lunare Xmake Repository - inifile Package
-- Category: Parsing, Data Formats & Templates
-- Simple, complete INI parser for Lua
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("inifile")
    set_homepage("https://github.com/bartbes/inifile")
    set_description("Simple, complete INI parser for Lua.")
    set_license("BSD-2-Clause")

    add_urls("https://github.com/bartbes/inifile/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/bartbes/inifile.git")

    add_versions("v1.1", "3beb7db2d8ade8658152329c3644c8403300dc780d2dba346e612e45ef01ac24")
    add_versions("v1.0", "5b9365c66145c3b4aeb0d997aff974e0acff60067a804adcf0ba05ead0e450fb")


    on_load(function (package)
        import("@addon.recudo.lua.runtime").setup(package, {
            runtime = {"lua", "luajit"},
            default = "lua",
        })
    end)


    on_install(function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            includes("@addon/recudo/recudo.lua")

            target("inifile")
                add_rules("recudo.lua.module")
                add_files("inifile.lua")
        ]])
        import("@addon.recudo.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.recudo.lua.module").lua_test(package, "local ini = require('inifile'); local t = ini.parse('[s]\\na=1\\n', 'memory'); assert(t.s.a == 1 or t.s.a == '1')")
    end)
