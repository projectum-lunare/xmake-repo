-- Projectum Lunare Xmake Repository - pgmoon Package
-- Category: Databases & Storage
-- Pure Lua PostgreSQL client driver
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("pgmoon")
    set_homepage("https://github.com/leafo/pgmoon")
    set_description("PostgreSQL driver written in pure Lua.")
    set_license("MIT")

    add_urls("https://github.com/leafo/pgmoon/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/leafo/pgmoon.git")

    add_versions("v1.18.0", "1d11cde905533a76911808c0930470638fba10415f2ac4fe15c3edfd55edae55")
    add_versions("v1.17.0", "becae9131253f718a316aa79fe80858a0eec546f6ddc3020a5429e91e56d219f")

    if is_plat("windows", "mingw", "linux", "macosx", "bsd", "haiku") then
        add_deps("luasocket", {configs = {shared = true}})
        add_deps("lpeg", {configs = {shared = true}})
    else
        add_deps("luasocket")
        add_deps("lpeg")
    end

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

            target("pgmoon")
                add_rules("recudo.lua.module")
                add_files("pgmoon.lua")
                add_files("pgmoon/*.lua", {prefixdir = "pgmoon"})
        ]])
        import("@addon.recudo.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.recudo.lua.module").lua_test(package, "local pgmoon = require('pgmoon'); local pg = pgmoon.new({database = 'test'}); assert(pg)")
    end)
