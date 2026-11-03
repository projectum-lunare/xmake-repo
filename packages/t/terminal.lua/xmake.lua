-- Projectum Lunare Xmake Repository - terminal.lua Package
-- Category: CLI, Terminal & Text UI
-- Cross platform terminal library for Lua
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("terminal.lua")
    set_homepage("https://github.com/lunarmodules/terminal.lua")
    set_description("Cross platform terminal library for Lua (Windows/Unix/Mac).")
    set_license("MIT")

    add_urls("https://github.com/lunarmodules/terminal.lua/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/lunarmodules/terminal.lua.git")

    add_versions("0.1.0", "2097d5c66cb1e0def36f68233ae032619385d3753e799d5fccd8a83a65d48133")

    if is_plat("windows", "mingw", "linux", "macosx", "bsd", "haiku") then
        add_deps("luasystem", {configs = {shared = true}})
    else
        add_deps("luasystem")
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

            target("terminal")
                add_rules("recudo.lua.module")
                add_packages("lua")
                add_files("src/terminal/**.lua")
        ]])
        import("@addon.recudo.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.recudo.lua.module").lua_test(package, [[
            local terminal = require("terminal")
            assert(terminal)
            assert(terminal.output)
            assert(terminal.cursor)
            assert(terminal.clear)
        ]])
    end)
