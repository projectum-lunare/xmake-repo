-- Projectum Lunare Xmake Repository - MD5 Package
-- Category: Data Structures, Concurrency & Utilities
-- Cryptographic facilities for Lua: MD5 and DES56
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("md5")
    set_homepage("https://github.com/lunarmodules/md5")
    set_description("Cryptographic facilities for Lua: MD5 hash function and DES56 encryption.")
    set_license("MIT")

    add_urls("https://github.com/lunarmodules/md5/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/lunarmodules/md5.git")

    add_versions("1.3", "0747a88d89c5d9b71e15fd614ac77a027627ce9ed222d3eb9ddee66f9fd46da4")

    add_deps("lua")
    add_deps("recudo master", {kind = "addon"})

    on_install(function (package)
        io.writefile("xmake.lua", [[
            target("md5")
                add_rules("recudo.lua.module")
                add_files("src/md5.lua")

            target("md5.core")
                add_rules("recudo.lua.module")
                add_files("src/compat-5.2.c", "src/md5.c", "src/md5lib.c")
                add_includedirs("src")

            target("des56")
                add_rules("recudo.lua.module")
                add_files("src/compat-5.2.c", "src/des56.c", "src/ldes56.c")
                add_includedirs("src")
        ]])
        import("@addon.recudo.lua.module").install_project(package)
    end)

    on_test(function (package)
        if package:is_plat("linux", "macosx", "bsd", "windows", "mingw") and not package:config("shared") then
            return
        end
        import("@addon.recudo.lua.module").lua_test(package, [[
            local md5 = require("md5")
            assert(md5 and md5.sumhexa)
            assert(md5.sumhexa("hello") == "5d41402abc4b2a76b9719d911017c592")
            local des56 = require("des56")
            assert(des56 and des56._VERSION)
        ]])
    end)
