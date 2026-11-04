-- Projectum Lunare Xmake Repository - cpml Package
-- Category: Game Development (Math & Physics)
-- Cirno's Perfect Math Library for 2D and 3D games (vectors, matrices, quaternions)
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("cpml")
    set_homepage("https://github.com/excessive/cpml")
    set_description("Cirno's Perfect Math Library: 2D and 3D game math (vectors, matrices, quaternions, geometry).")
    set_license("MIT")

    add_urls("https://github.com/excessive/cpml/archive/refs/tags/v$(version).tar.gz")
    add_urls("https://github.com/excessive/cpml.git")

    add_versions("1.0.0", "9297137c458c9f8aa1012550eab4188e3d24dbc8da9539c8c2cff1e2004e5182")

    on_load(function (package)
        import("@addon.recudo.lua.runtime").setup(package, {
            runtime = {"lua", "luajit"},
            default = "lua",
        })
    end)

    on_install(function (package)
        os.mkdir("cpml")
        os.cp("init.lua", "cpml/init.lua")
        os.cp("modules", "cpml/")
        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            includes("@addon/recudo/recudo.lua")

            target("cpml")
                add_rules("recudo.lua.module")
                add_packages("lua")
                add_files("cpml/**.lua")
        ]])
        import("@addon.recudo.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.recudo.lua.module").lua_test(package, [[
            local cpml = require("cpml")
            local v = cpml.vec2(3, 4)
            assert(v:len() == 5)
            local v3 = cpml.vec3(1, 2, 3)
            assert(v3.x == 1 and v3.y == 2 and v3.z == 3)
        ]])
    end)
