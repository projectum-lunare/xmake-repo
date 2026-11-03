-- Projectum Lunare Xmake Repository - lua-lace Package
-- Category: Networking, Web & Services
-- Lua Access Control Engine modelled on Squid's acl syntax
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("lua-lace")
    set_homepage("https://github.com/lunarmodules/lua-lace")
    set_description("A simple access control engine modelled on Squid's acl syntax.")
    set_license("BSD-3-Clause")

    add_urls("https://github.com/lunarmodules/lua-lace/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/lunarmodules/lua-lace.git")

    add_versions("v1.4", "8e50bb0589655b0607ed8ba4031093799f7d0a4670c9b36a53126f44bfacf54c")
    add_versions("v1.3.1", "8cadcda0ec3240a8f633af81aece9e9d9cc185c31f32ce1d8d0e491332cee4b3")


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

            target("lace")
                add_rules("recudo.lua.module")
                add_files("lib/lace.lua")
                add_files("lib/lace/*.lua", {prefixdir = "lace"})
        ]])
        import("@addon.recudo.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.recudo.lua.module").lua_test(package, "assert(require('lace'))")
    end)
