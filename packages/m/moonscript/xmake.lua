-- Projectum Lunare Xmake Repository - moonscript Package
-- Category: Languages & Transpilers (Compile-to-Lua)
-- A programmer friendly language that compiles to Lua
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("moonscript")
    set_homepage("https://moonscript.org")
    set_description("A programmer friendly language that compiles to Lua.")
    set_license("MIT")

    add_urls("https://github.com/leafo/moonscript/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/leafo/moonscript.git")

    add_versions("v0.8.0", "0458ba86359c9089f823f81e4198ea3f7d57c2f2773fb8a1364940ebdd802ac5")
    add_versions("v0.7.0", "98fcf86d47694c81ccf9012e310f86d443ddf516e90b267ea33eb7ff1b0747c4")

    add_deps("argparse")
    if is_plat("windows", "mingw", "linux", "macosx", "bsd", "haiku") then
        add_deps("lpeg", {configs = {shared = true}})
        add_deps("luafilesystem", {configs = {shared = true}})
    else
        add_deps("lpeg")
        add_deps("luafilesystem")
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

            target("moonscript.parse.native")
                add_rules("recudo.lua.module")
                add_files("moonscript/parse/native.c")

            target("moonscript")
                add_rules("recudo.lua.module")
                set_values("recudo.lua.rootdir", os.projectdir())
                add_files("moonscript/**.lua")
                add_files("moon/**.lua")

            target("moon")
                add_rules("recudo.lua.bin")
                add_files("bin/moon")

            target("moonc")
                add_rules("recudo.lua.bin")
                add_files("bin/moonc")
        ]])
        import("@addon.recudo.lua.module").install_project(package)
    end)

    on_test(function (package)
        if package:config("shared") or not package:is_plat("linux", "macosx", "bsd", "windows", "mingw") then
            import("@addon.recudo.lua.module").lua_test(package, [[
                local moonscript = require("moonscript.base")
                local code = moonscript.to_lua("x = 10\nprint x")
                assert(code:find("local x = 10"))
            ]])
        end
        import("@addon.recudo.lang.moonscript").test(package, [[
            x = 10
            assert x == 10
        ]])
    end)
