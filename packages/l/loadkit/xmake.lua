-- Projectum Lunare Xmake Repository - loadkit Package
-- Load arbitrary files within the Lua package path
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("loadkit")
    set_homepage("https://github.com/leafo/loadkit")
    set_description("Load arbitrary files within the Lua package path.")
    set_license("MIT")

    add_urls("https://github.com/leafo/loadkit/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/leafo/loadkit.git")

    add_versions("v1.1.0", "39742dd5db94f13886810cf69fc9b3db89bba3180c060384136115c9da431196")
    add_versions("v1.0.0", "91469e524100df0fbfc8e615d82b708a00d84221c4b00ac62595745abed4c1db")

    add_deps("lua")
    add_deps("forge master", {kind = "addon"})

    on_install(function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            includes("@addon/forge/forge.lua")

            target("loadkit")
                add_rules("forge.lua.module")
                add_files("loadkit.lua")
        ]])
        import("@addon.forge.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.forge.lua.module").lua_test(package, "local loadkit = require('loadkit'); assert(type(loadkit.make_loader) == 'function')")
    end)
