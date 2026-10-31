-- Projectum Lunare Xmake Repository - lua-cliargs Package
-- Category: CLI, Terminal & Text UI
-- A command-line argument parsing module for Lua
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("lua-cliargs")
    set_homepage("https://github.com/lunarmodules/lua_cliargs")
    set_description("A command-line argument parsing module for Lua.")
    set_license("MIT")

    add_urls("https://github.com/lunarmodules/lua_cliargs/archive/refs/tags/v$(version).tar.gz")
    add_urls("https://github.com/lunarmodules/lua_cliargs.git")

    add_versions("3.0.2", "a7a57ab9c73f6c44040a78305b6dc7780ca1565cc4c9057d74a6608cb0443af4")

    add_deps("lua")
    add_deps("forge master", {kind = "addon"})

    on_install(function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            includes("@addon/forge/forge.lua")

            target("cliargs")
                add_rules("forge.lua.module")
                add_packages("lua")
                add_files("src/**.lua")
        ]])
        import("@addon.forge.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.forge.lua.module").lua_test(package, [[
            local cli = require("cliargs")
            assert(cli.VERSION)
            cli:flag("-f, --force", "force flag")
            local args, err = cli:parse({"-f"})
            assert(args and args["f"] == true)
        ]])
    end)
