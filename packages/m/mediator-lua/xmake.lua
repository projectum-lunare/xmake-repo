-- Projectum Lunare Xmake Repository - mediator-lua Package
-- A mediator pattern implementation for event-driven systems in Lua
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("mediator-lua")
    set_homepage("https://github.com/Olivine-Labs/mediator_lua")
    set_description("A mediator pattern implementation for event-driven systems in Lua.")
    set_license("MIT")

    add_urls("https://github.com/Olivine-Labs/mediator_lua/archive/refs/tags/v$(version)-0.tar.gz")
    add_urls("https://github.com/Olivine-Labs/mediator_lua.git")

    add_versions("1.1.2", "faf5859fd2081be4e9e4fb8873a2dc65f7eff3fd93d6dd14da65f8e123fcff9b")
    add_versions("1.1.1", "e1e2fca724fe1e553390cf4e3b52ccc78e0fef725e3d77b064089595cc6a06da")

    add_deps("lua")
    add_deps("forge master", {kind = "addon"})

    on_install(function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            includes("@addon/forge/forge.lua")

            target("mediator")
                add_rules("forge.lua.module")
                add_packages("lua")
                add_files("src/mediator.lua")
        ]])
        import("@addon.forge.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.forge.lua.module").lua_test(package, [[
            local Mediator = require("mediator")
            local m = Mediator()
            local called = false
            m:subscribe({ "test" }, function () called = true end)
            m:publish({ "test" })
            assert(called)
        ]])
    end)
