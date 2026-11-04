-- Projectum Lunare Xmake Repository - fifo.lua Package
-- Category: Data Structures & Algorithms
-- Pure Lua FIFO queue data structure library
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("fifo.lua")
    set_homepage("https://github.com/daurnimator/fifo.lua")
    set_description("A pure Lua FIFO (first-in, first-out) queue library.")
    set_license("MIT")

    add_urls("https://github.com/daurnimator/fifo.lua/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/daurnimator/fifo.lua.git")

    add_versions("0.2", "85cad0c2f9eac1cd3e08c5134feb655e0b928e1e22363c3ef3293a194c0eb53f")

    on_load(function (package)
        import("@addon.recudo.lua.runtime").setup(package, {
            runtime = {"lua", "luajit"},
            default = "lua",
        })
    end)

    on_install(function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            includes("@addon/recudo/recudo.lua")

            target("fifo")
                add_rules("recudo.lua.module")
                add_packages("lua")
                add_files("fifo.lua")
        ]])
        import("@addon.recudo.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.recudo.lua.module").lua_test(package, [[
            local fifo = require("fifo")
            local q = fifo()
            q:push(1)
            q:push(2)
            assert(q:pop() == 1)
            assert(q:pop() == 2)
            assert(q:length() == 0)
        ]])
    end)
