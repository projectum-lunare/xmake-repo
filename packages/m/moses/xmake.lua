-- Projectum Lunare Xmake Repository - moses Package
-- Utility library for Lua centered around functional programming
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("moses")
    set_homepage("https://github.com/Yonaba/Moses")
    set_description("Utility library for Lua centered around functional programming, similar to Underscore.js.")
    set_license("MIT")

    add_urls("https://github.com/Yonaba/Moses/archive/refs/tags/Moses-$(version)-1.tar.gz")
    add_urls("https://github.com/Yonaba/Moses.git")

    add_versions("2.1.0", "92818397ede48d5d0491e793b26739cee5689634fbb38ec4b7cc3c2683dfbf58")
    add_versions("2.0.0", "98073633d5bae356e6a1f275468386a2eaec249222e49f022cc6b3817aaeab41")

    add_deps("lua")
    add_deps("forge master", {kind = "addon"})

    on_install(function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            includes("@addon/forge/forge.lua")

            target("moses")
                add_rules("forge.lua.module")
                add_files("moses.lua")
        ]])
        import("@addon.forge.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.forge.lua.module").lua_test(package, "local _ = require('moses'); assert(_.isEqual({1, 2}, {1, 2}))")
    end)
