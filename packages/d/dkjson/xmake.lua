-- Projectum Lunare Xmake Repository - dkjson Package
-- Category: Parsing, Data Formats & Templates
-- David Kolf's JSON module for Lua
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("dkjson")
    set_homepage("http://dkolf.de/src/dkjson-lua.fsl/")
    set_description("David Kolf's JSON module for Lua.")
    set_license("MIT")

    add_urls("https://github.com/LuaDist/dkjson/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/LuaDist/dkjson.git")

    add_versions("2.5", "8560ee3c7ed421b293bf0905017bc90bd2f282d56517aa59ec6c53f5fb4057bd")
    add_versions("2.4", "35fd51c22ab0ad1134cd3e5a3b0998aa435ea68e547045689880818b1c441303")


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

            target("dkjson")
                add_rules("recudo.lua.module")
                add_packages("lua")
                add_files("dkjson.lua")
        ]])
        import("@addon.recudo.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.recudo.lua.module").lua_test(package, [[
            local json = require("dkjson")
            local str = json.encode({ status = "ok" })
            local obj = json.decode(str)
            assert(obj and obj.status == "ok")
        ]])
    end)
