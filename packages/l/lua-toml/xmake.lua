-- Projectum Lunare Xmake Repository - lua-toml Package
-- Category: Parsing, Data Formats & Serialization
-- A simple, compliant TOML parser and serializer for Lua
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("lua-toml")
    set_homepage("https://github.com/jonstoler/lua-toml")
    set_description("A simple, compliant TOML parser and serializer for Lua.")
    set_license("MIT")

    add_urls("https://github.com/jonstoler/lua-toml/archive/refs/tags/v$(version).tar.gz")
    add_urls("https://github.com/jonstoler/lua-toml.git")

    add_versions("2.0.1", "c532bfcebaf9f1a38614a50df2b0e7b8fe90fa3ee98c73062556030c54affe49")

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

            target("toml")
                add_rules("recudo.lua.module")
                add_packages("lua")
                add_files("toml.lua")
        ]])
        import("@addon.recudo.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.recudo.lua.module").lua_test(package, [[
            local toml = require("toml")
            local parsed = toml.parse('title = "TOML Example"\n[owner]\nname = "Tom"')
            assert(parsed.title == "TOML Example")
            assert(parsed.owner.name == "Tom")
        ]])
    end)
