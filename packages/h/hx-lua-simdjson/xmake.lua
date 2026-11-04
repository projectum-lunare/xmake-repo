-- Projectum Lunare Xmake Repository - hx-lua-simdjson Package
-- Category: Parsers & Formats
-- High-performance simdjson binding for Lua and Haxe Lua target
-- Supported Platforms: Linux, macOS, Windows, BSD

package("hx-lua-simdjson")
    set_homepage("https://github.com/HaxeFoundation/hx-lua-simdjson")
    set_description("High-performance simdjson binding for Lua and Haxe Lua target.")
    set_license("Apache-2.0")

    add_urls("https://github.com/HaxeFoundation/hx-lua-simdjson/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/HaxeFoundation/hx-lua-simdjson.git")

    add_versions("0.0.2", "e794d6d95a1c0c20a2c3e46ac9814f75e30cd8ea5a9f583ce5807b43217b0b81")
    add_versions("0.0.1", "97e78f807a72c980e54490d5de1a17f85c473657464c3471d9683226e9839733")
    add_versions("0.0.0", "0c5f4ec9928d73b075afa9a8b2bf3ac93042b2b2ae4c2d62a6f81b133a2b8195")

    on_load(function (package)
        import("@addon.recudo.lua.runtime").setup(package, {
            runtime = {"lua", "luajit"},
        })
    end)

    on_install(function (package)
        io.writefile("xmake.lua", [[
            target("hxsimdjson")
                add_rules("recudo.lua.module")
                set_languages("c++17")
                add_includedirs("src")
                add_files("src/hxluasimdjson.cpp", "src/simdjson.cpp")
                if is_plat("linux", "bsd") then
                    add_syslinks("pthread")
                end
        ]])
        import("@addon.recudo.lua.module").install_project(package)
    end)

    on_test(function (package)
        if package:is_plat("linux", "macosx", "bsd") and not package:config("shared") then
            return
        end
        import("@addon.recudo.lua.module").lua_test(package, [[
            local simd = require("hxsimdjson")
            assert(simd and type(simd.parse) == "function")
            local obj = simd.parse('{"key":"value"}')
            assert(obj and obj.key == "value")
        ]])
    end)
