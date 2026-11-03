-- Projectum Lunare Xmake Repository - inspect Package
-- Category: Data Structures, Concurrency & Utilities
-- Human-readable representation of Lua tables
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("inspect")
    set_homepage("https://github.com/kikito/inspect.lua")
    set_description("Human-readable representation of Lua tables.")
    set_license("MIT")

    add_urls("https://github.com/kikito/inspect.lua/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/kikito/inspect.lua.git")

    add_versions("v3.1.3", "43386a613f9916186af4919f36392d8b8dad8c4428a5f8c85ebac80acba71eeb")
    add_versions("v3.1.2", "6b5856d04bc9ab12a5849dd529bb5f6a986a8cb7447f8824479aedbaca259622")


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

            target("inspect")
                add_rules("recudo.lua.module")
                add_files("inspect.lua")
        ]])
        import("@addon.recudo.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.recudo.lua.module").lua_test(package, "local inspect = require('inspect'); assert(type(inspect({a = 1})) == 'string')")
    end)
