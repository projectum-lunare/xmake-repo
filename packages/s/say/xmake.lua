-- Projectum Lunare Xmake Repository - say Package
-- Category: Testing, Code Quality & Documentation
-- Simple string key/value store for i18n or any other case where strings need to be stored
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("say")
    set_homepage("https://github.com/lunarmodules/say")
    set_description("Simple string key/value store for i18n or any other case where strings need to be stored.")
    set_license("MIT")

    add_urls("https://github.com/lunarmodules/say/archive/refs/tags/v$(version).tar.gz")
    add_urls("https://github.com/lunarmodules/say.git")

    add_versions("1.4.1", "ce07547ca49ef42cc799e2a30b3c65ce77039978e32e7961799a252d61a56486")
    add_versions("1.4.0", "b81e7519ebdff47e1aee69b2a53eda201824cdd7a15e743ff322b8e4fde350cb")

    add_deps("lua")
    add_deps("forge master", {kind = "addon"})

    on_install(function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            includes("@addon/forge/forge.lua")

            target("say")
                add_rules("forge.lua.module")
                add_packages("lua")
                add_files("src/say/init.lua")
        ]])
        import("@addon.forge.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.forge.lua.module").lua_test(package, [[
            local say = require("say")
            say:set_namespace("en")
            say:set("hello", "world")
            assert(say("hello") == "world")
        ]])
    end)
