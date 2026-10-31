-- Projectum Lunare Xmake Repository - lua-term Package
-- Category: CLI, Terminal & Text UI
-- Terminal manipulation library for Lua
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("lua-term")
    set_homepage("https://github.com/hoelzro/lua-term")
    set_description("Terminal manipulation library for Lua.")
    set_license("MIT")

    add_urls("https://github.com/hoelzro/lua-term/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/hoelzro/lua-term.git")

    add_versions("0.8", "0cb270be22dfc262beec2f4ffc66b878ccaf236f537d693fa36c8f578fc51aa6")
    add_versions("0.7", "d91d41b29552b2d0849323f94e274df7eee613fc8ec3d82ed1fae749246a5d25")

    add_deps("lua")
    add_deps("forge master", {kind = "addon"})

    on_install(function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            includes("@addon/forge/forge.lua")

            target("term.core")
                add_rules("forge.lua.module")
                add_packages("lua")
                add_files("core.c")
                if is_plat("windows") then
                    add_defines("isatty=_isatty", "fileno=_fileno")
                end

            target("term")
                add_rules("forge.lua.module")
                add_packages("lua")
                add_files("term/**.lua")
        ]])
        import("@addon.forge.lua.module").install_project(package)
    end)

    on_test(function (package)
        if package:is_plat("linux", "macosx", "bsd") and not package:config("shared") then
            -- Lua modules built statically cannot be dlopen'd by standalone lua
            return
        end
        import("@addon.forge.lua.module").lua_test(package, [[
            local term = require("term")
            assert(term.colors)
            assert(term.cursor)
            assert(type(term.isatty) == "function")
        ]])
    end)
