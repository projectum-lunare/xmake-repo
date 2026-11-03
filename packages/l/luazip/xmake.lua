-- Projectum Lunare Xmake Repository - LuaZip Package
-- Category: System, Hardware & Native Bindings
-- Library for reading files inside zip files
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("luazip")
    set_homepage("https://github.com/lunarmodules/luazip")
    set_description("Lua extension library used to read files stored inside zip files.")
    set_license("MIT")

    add_urls("https://github.com/lunarmodules/luazip/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/lunarmodules/luazip.git")

    add_versions("1.2.7", "d01848f7d9d43972b99635de41a0e3d6e266264564103f8536d37bdb9372edb7")
    add_versions("1.2.6", "d679a412e875b176d9b2ff9bb05d7c08f6f92cecdc3b53b87def6a2d9844ce25")

    add_deps("lua")
    if is_plat("windows", "mingw", "linux", "macosx", "bsd", "haiku") then
        add_deps("zziplib", {configs = {shared = true}})
    else
        add_deps("zziplib")
    end
    add_deps("recudo master", {kind = "addon"})

    on_install(function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            add_requires("zziplib")

            target("zip")
                add_rules("recudo.lua.module")
                add_packages("zziplib")
                add_includedirs("src")
                add_files("src/luazip.c")
        ]])
        import("@addon.recudo.lua.module").install_project(package)
    end)

    on_test(function (package)
        if package:is_plat("linux", "macosx", "bsd", "windows", "mingw") and not package:config("shared") then
            return
        end
        import("@addon.recudo.lua.module").lua_test(package, [[
            local zip = require("zip")
            assert(zip and zip.open)
            assert(zip._VERSION)
        ]])
    end)
