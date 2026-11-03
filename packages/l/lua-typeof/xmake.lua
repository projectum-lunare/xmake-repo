-- Projectum Lunare Xmake Repository - lua-typeof Package
-- Category: Data Structures, Concurrency & Utilities
-- Type check library for Lua
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("lua-typeof")
    set_homepage("https://github.com/iresty/lua-typeof")
    set_description("Type check library for Lua.")
    set_license("Apache-2.0")

    add_urls("https://github.com/iresty/lua-typeof/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/iresty/lua-typeof.git")

    add_versions("v0.1", "b8369cad3cadb402c4ae0318c4bb26c56c4c9b2dfb1a3ecf6411e8d09b36ecd5")

    add_deps("lua")
    add_deps("recudo master", {kind = "addon"})

    on_install(function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            includes("@addon/recudo/recudo.lua")

            target("lua-typeof")
                add_rules("recudo.lua.module")
                add_packages("lua")
                add_files("lib/**.lua")
        ]])
        import("@addon.recudo.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.recudo.lua.module").lua_test(package, [[
            local typeof = require("typeof")
            assert(typeof.string("hello"))
            assert(typeof.table({}))
            assert(typeof.number(42))
        ]])
    end)
