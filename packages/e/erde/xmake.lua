-- Projectum Lunare Xmake Repository - Erde Package
-- Category: Languages, Compilers & Dialects
-- A modern Lua dialect inspired by Rust, Go and JavaScript
-- Supported Platforms: All platforms supporting Lua (POSIX, Windows, Vintage, Embedded)

package("erde")
    set_homepage("https://erde-lang.github.io/")
    set_description("Erde is a modern programming language that compiles to Lua.")
    set_license("MIT")

    add_urls("https://github.com/erde-lang/erde/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/erde-lang/erde.git")

    add_versions("1.0.0-1", "fb7a0a2cb5c0c95fd1fc797187030208317558c716698391977bc2c4d36b4126")

    add_deps("luafilesystem")

    set_kind("library", {headeronly = true})
    add_bindirs("bin")

    on_load(function (package)
        import("@addon.recudo.lua.runtime").setup(package, {
            runtime = {"lua", "luajit"},
            default = "lua",
        })
    end)

    on_install(function (package)
        io.writefile("xmake.lua", [[
            target("erde")
                add_rules("recudo.lua.module")
                add_files("erde/**.lua")

            target("erde.bin")
                add_rules("recudo.lua.bin")
                set_values("recudo.lua.entry", "erde/cli.lua")
                add_files("erde/cli.lua")
                add_deps("erde")
        ]])
        import("@addon.recudo.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.recudo.lua.module").lua_test(package, [[
            local erde = require("erde")
            assert(erde and erde.compile)
            local lua_code = erde.compile('print("hello from erde")')
            assert(lua_code and lua_code:find("hello from erde", 1, true))
        ]])
    end)
