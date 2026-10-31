-- Projectum Lunare Xmake Repository - busted Package
-- Elegant Lua unit testing
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("busted")
    set_homepage("https://lunarmodules.github.io/busted/")
    set_description("An elegant, extensible testing framework for Lua.")
    set_license("MIT")

    add_urls("https://github.com/lunarmodules/busted/archive/refs/tags/v$(version).tar.gz")
    add_urls("https://github.com/lunarmodules/busted.git")

    add_versions("2.3.0", "1669a4f59ff9e08ad4b38d4212ad8cdd4519209101e3af5459a596d5ad9a7d24")
    add_versions("2.2.0", "befca10f573bb476fa1db2e3149150d65f802a71d34d1682679e640665f2dc2b")
    add_versions("2.1.2", "445519fa663dbdd21e8a6ecf1609f397d0e2168440e59ee29198ee687321e9a3")

    add_deps("lua")
    add_deps("lua-cliargs")
    add_deps("dkjson")
    add_deps("say")
    add_deps("luassert")
    add_deps("penlight")
    add_deps("mediator_lua")
    if is_plat("windows", "mingw", "linux", "macosx", "bsd", "haiku") then
        add_deps("luasystem", {configs = {shared = true}})
        add_deps("lua-term", {configs = {shared = true}})
    else
        add_deps("luasystem")
        add_deps("lua-term")
    end
    add_deps("forge master", {kind = "addon"})

    add_bindirs("bin")

    on_install(function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            includes("@addon/forge/forge.lua")

            target("busted")
                add_rules("forge.lua.module")
                add_packages("lua")
                add_files("busted/**.lua")

            target("busted-bin")
                add_rules("forge.lua.bin")
                add_files("bin/busted")
        ]])
        import("@addon.forge.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.forge.lua.module").lua_test(package, [[
            local busted = require("busted")
            assert(busted)
            local runner = require("busted.runner")
            assert(runner)
        ]])
    end)
