-- Projectum Lunare Xmake Repository - lualogging Package
-- A simple API to use logging features in Lua
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("lualogging")
    set_homepage("https://github.com/lunarmodules/lualogging")
    set_description("A simple API to use logging features in Lua.")
    set_license("MIT")

    add_urls("https://github.com/lunarmodules/lualogging/archive/refs/tags/v$(version).tar.gz")
    add_urls("https://github.com/lunarmodules/lualogging.git")

    add_versions("1.8.2", "30655889db14104f1509d20ba423a43ea8ce85f4289acdcf6b62477159482c60")
    add_versions("1.8.1", "7ee1c561580a2d832035c2b27510ed6adce3f9c0ae845a5a3356a416b330b0d6")
    add_versions("1.8.0", "44a085633e545b5ea446e8ac7ff352f983e6b9eb30033f0fd69c89b535bd19fc")
    add_versions("1.7.0", "e8665ff75ffb529c7d9bf47e4501f45c291b029ab50c96ad5e946a5cb30bb03b")
    add_versions("1.6.0", "92a68e9a45a896a562135c876ef4fdc780f93eef14ed8a1796d4b35c00a589bc")

    add_deps("lua")
    if is_plat("windows", "mingw", "linux", "macosx", "bsd", "haiku") then
        add_deps("luasocket", {configs = {shared = true}})
    else
        add_deps("luasocket")
    end
    add_deps("forge master", {kind = "addon"})

    on_install(function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            includes("@addon/forge/forge.lua")

            target("logging")
                add_rules("forge.lua.module")
                add_packages("lua")
                add_files("src/logging.lua")
                add_files("src/logging/**.lua")
        ]])
        import("@addon.forge.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.forge.lua.module").lua_test(package, [[
            local logging = require("logging")
            assert(logging and logging._VERSION)
            require("logging.console")
            local logger = logging.console()
            assert(logger)
        ]])
    end)
