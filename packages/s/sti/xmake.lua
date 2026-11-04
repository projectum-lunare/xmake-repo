-- Projectum Lunare Xmake Repository - sti Package
-- Category: Game Development (Scene, Assets & Resources)
-- Simple Tiled Implementation (STI) map loader and renderer for Lua and LÖVE
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("sti")
    set_homepage("https://github.com/karai17/Simple-Tiled-Implementation")
    set_description("Simple Tiled Implementation is a fast Tiled Map Editor format loader and renderer for Lua and LÖVE.")
    set_license("MIT")

    add_urls("https://github.com/karai17/Simple-Tiled-Implementation/archive/refs/tags/v$(version).tar.gz")
    add_urls("https://github.com/karai17/Simple-Tiled-Implementation.git")

    add_versions("1.2.3.0", "847409d1f8dbe839659de5bf2061a72605dd11e8b531c2e3fa511dfc6fc67c72")

    on_load(function (package)
        import("@addon.recudo.lua.runtime").setup(package, {
            runtime = {"lua", "luajit"},
            default = "lua",
        })
    end)

    on_install(function (package)
        io.replace("sti/graphics.lua", "local lg       = _G.love.graphics", "local lg       = _G.love and _G.love.graphics", {plain = true})

        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            includes("@addon/recudo/recudo.lua")

            target("sti")
                add_rules("recudo.lua.module")
                add_packages("lua")
                add_files("sti/**.lua")
        ]])
        import("@addon.recudo.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.recudo.lua.module").lua_test(package, [[
            local sti = require("sti")
            assert(type(sti) == "table")
            assert(sti._VERSION == "1.2.3.0")
        ]])
    end)
