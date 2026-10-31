-- Projectum Lunare Xmake Repository - luassert Package
-- Lua assertions extension library
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("luassert")
    set_homepage("https://github.com/lunarmodules/luassert")
    set_description("Lua assertions extension library.")
    set_license("MIT")

    add_urls("https://github.com/lunarmodules/luassert/archive/refs/tags/v$(version).tar.gz")
    add_urls("https://github.com/lunarmodules/luassert.git")

    add_versions("1.9.0", "1db0fabf1bd87392860375b89a8a37d17b687325c988be0df8c42e7e96e7ed73")
    add_versions("1.8.0", "5955234a63fdc208674314b2e97982bb551459b85b8ff11611a50421c6a29c76")

    add_deps("lua")
    add_deps("say")
    add_deps("forge master", {kind = "addon"})

    on_install(function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            includes("@addon/forge/forge.lua")

            target("luassert")
                add_rules("forge.lua.module")
                add_packages("lua")
                set_values("forge.lua.parent_module", "luassert")
                add_files("src/**.lua")
        ]])
        import("@addon.forge.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.forge.lua.module").lua_test(package, [[
            local assert = require("luassert")
            assert.True(true)
            assert.False(false)
            assert.are.equal(123, 123)
        ]])
    end)
