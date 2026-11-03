-- Projectum Lunare Xmake Repository - lapis Package
-- Category: Networking, Web & Services
-- A web framework for MoonScript and Lua
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("lapis")
    set_homepage("https://leafo.net/lapis")
    set_description("A web framework for MoonScript and Lua.")
    set_license("MIT")

    add_urls("https://github.com/leafo/lapis/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/leafo/lapis.git")

    add_versions("v1.19.0", "15c6b5f8a26b7db5f0abd2d348112fad31d816eb961080f0fb5ec7a054913e7d")
    add_versions("v1.18.0", "5d7a8e291bc9c87318071739b1da059f20b0e85230c8966dc2eacce0853ae5dc")

    add_deps("ansicolors")
    add_deps("argparse")
    add_deps("date")
    add_deps("etlua")
    add_deps("loadkit")
    add_deps("pgmoon")
    if is_plat("windows", "mingw", "linux", "macosx", "bsd", "haiku") then
        add_deps("lpeg", {configs = {shared = true}})
        add_deps("lua-cjson", {configs = {shared = true}})
        add_deps("luafilesystem", {configs = {shared = true}})
        add_deps("luasocket", {configs = {shared = true}})
        add_deps("luaossl", {configs = {shared = true}})
    else
        add_deps("lpeg")
        add_deps("lua-cjson")
        add_deps("luafilesystem")
        add_deps("luasocket")
        add_deps("luaossl")
    end
    add_bindirs("bin")

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

            target("lapis")
                add_rules("recudo.lua.module")
                set_values("recudo.lua.rootdir", os.projectdir())
                add_files("lapis/**.lua")

            target("lapis-bin")
                add_rules("recudo.lua.bin")
                add_files("bin/lapis")
        ]])
        import("@addon.recudo.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.recudo.lua.module").lua_test(package, [[
            local lapis = require("lapis")
            assert(lapis.Application)
            assert(lapis.serve)
        ]])
    end)
