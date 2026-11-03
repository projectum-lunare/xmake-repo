-- Projectum Lunare Xmake Repository - binaryheap Package
-- Category: Data Structures, Concurrency & Utilities
-- Binary heap implementation in pure Lua
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("binaryheap")
    set_homepage("https://github.com/Tieske/binaryheap.lua")
    set_description("A Binary Heap implementation in pure Lua.")
    set_license("MIT")

    add_urls("https://github.com/Tieske/binaryheap.lua/archive/refs/tags/version_$(version).tar.gz", {version = function (version)
        local parts = version:split("%.")
        return "0v" .. parts[#parts]
    end})
    add_urls("https://github.com/Tieske/binaryheap.lua.git")

    add_versions("0.4", "10b1b6c6f2d22560f512f9896a6672ec5ae0eea1390ff8e662be1d5d9625b438")
    add_versions("0.3", "e25ac29abf9e22c8e4aae0b02255d0dd2e35a27a39b90fb6a24b179805eb8049")


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

            target("binaryheap")
                add_rules("recudo.lua.module")
                add_packages("lua")
                add_files("src/binaryheap.lua")
        ]])
        import("@addon.recudo.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.recudo.lua.module").lua_test(package, [[
            local binaryheap = require("binaryheap")
            local h = binaryheap.minHeap()
            h:insert(10)
            h:insert(5)
            assert(h:pop() == 5)
            assert(h:pop() == 10)
        ]])
    end)
