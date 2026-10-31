-- Projectum Lunare Xmake Repository - etlua Package
-- Embedded templates for Lua
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("etlua")
    set_homepage("https://github.com/leafo/etlua")
    set_description("Embedded templates for Lua.")
    set_license("MIT")

    add_urls("https://github.com/leafo/etlua/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/leafo/etlua.git")

    add_versions("v1.3.0", "66e602779ebf9ad9ef7624fea6bcffe9ecc540691144f7f25fb97062df7a5994")
    add_versions("v1.2.0", "4a61ffc0226633e80c93c05badff7bcc608b3ce678e6111068083d8ec1f214ed")

    add_deps("lua")
    add_deps("forge master", {kind = "addon"})

    on_install(function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            includes("@addon/forge/forge.lua")

            target("etlua")
                add_rules("forge.lua.module")
                add_files("etlua.lua")
        ]])
        import("@addon.forge.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.forge.lua.module").lua_test(package, "local etlua = require('etlua'); local template = etlua.compile('Hello <%= name %>'); assert(template({name = 'world'}) == 'Hello world')")
    end)
