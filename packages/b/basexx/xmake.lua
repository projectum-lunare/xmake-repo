-- Projectum Lunare Xmake Repository - basexx Package
-- A base2, base16, base32, base64 and base85 library for Lua
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("basexx")
    set_homepage("https://github.com/aiq/basexx")
    set_description("A base2, base16, base32, base64 and base85 library for Lua.")
    set_license("MIT")

    add_urls("https://github.com/aiq/basexx/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/aiq/basexx.git")

    add_versions("v0.4.1", "ff62b00446df1181a9cd20ba970c3c8493165d262142e10d069ee3de6337dfe6")
    add_versions("v0.4.0", "f87570e849253d69cbda6dbdcbf1227f416e1dd3d145df341a397b858717a6fe")

    add_deps("lua")
    add_deps("forge master", {kind = "addon"})

    on_install(function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            includes("@addon/forge/forge.lua")

            target("basexx")
                add_rules("forge.lua.module")
                add_files("lib/basexx.lua")
        ]])
        import("@addon.forge.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.forge.lua.module").lua_test(package, "local basexx = require('basexx'); assert(basexx.to_base64('hello') == 'aGVsbG8=')")
    end)
