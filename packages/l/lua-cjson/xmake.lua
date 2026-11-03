-- Projectum Lunare Xmake Repository - lua-cjson Package
-- Category: OpenResty & NGINX Ecosystem
-- Fast JSON parsing and encoding support for Lua (OpenResty fork)
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("lua-cjson")
    set_homepage("https://github.com/openresty/lua-cjson")
    set_description("A fast JSON encoding/parsing module for Lua (OpenResty fork).")
    set_license("MIT")

    add_urls("https://github.com/openresty/lua-cjson/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/openresty/lua-cjson.git")

    add_versions("2.1.0.20", "a99fb872aa731274ac70453cd4e6b2e0e8fb978893063d512ca67c7c332510e1")
    add_versions("2.1.0.19", "d1aded44b4cfe5ec6b395e178902aba3eed1dbe7999a753c0662222de2890ec0")
    add_versions("2.1.0.18", "12a61858e47ddaf335cad20d4690683447ffa5d8dbce9e3146818fa60c00ac8e")
    add_versions("2.1.0.17", "510062d471fc9c4cd87b367a7b879c7a5f2af70513d97708842d097614d96188")
    add_versions("2.1.0.14", "14cac5c7a4520b33449a1fc961344556b8b6a2a2c6b739b0e46e3002e6e605bc")

    on_load(function (package)
        import("@addon.recudo.lua.runtime").setup(package, {
            runtime = {"lua", "luajit"},
        })
    end)

    add_includedirs("include", "include/cjson")
    add_bindirs("bin")

    on_install(function (package)
        io.writefile("xmake.lua", [[
            target("cjson")
                add_rules("recudo.lua.module")
                add_files("lua_cjson.c", "strbuf.c", "fpconv.c")
                add_headerfiles("*.h", {prefixdir = "cjson"})
                add_headerfiles("*.h")
                if is_plat("windows", "mingw") then
                    add_defines("DISABLE_INVALID_NUMBERS")
                    add_defines("_CRT_SECURE_NO_WARNINGS")
                end

            target("cjson.safe")
                add_rules("recudo.lua.module")
                add_files("lua_cjson.c", "strbuf.c", "fpconv.c")
                if is_plat("windows", "mingw") then
                    add_defines("DISABLE_INVALID_NUMBERS")
                    add_defines("_CRT_SECURE_NO_WARNINGS")
                end

            target("cjson.util")
                add_rules("recudo.lua.module")
                add_files("lua/cjson/util.lua")

            target("lua2json")
                add_rules("recudo.lua.bin")
                add_files("lua/lua2json.lua")

            target("json2lua")
                add_rules("recudo.lua.bin")
                add_files("lua/json2lua.lua")
        ]])
        import("@addon.recudo.lua.module").install_project(package)
    end)

    on_test(function (package)
        if package:config("shared") then
            import("@addon.recudo.lua.module").lua_test(package, [[
                local cjson = require("cjson")
                local safe = require("cjson.safe")
                local util = require("cjson.util")
                local s = cjson.encode({hello = "world"})
                assert(cjson.decode(s).hello == "world")
                assert(safe.decode(s).hello == "world")
            ]])
        else
            assert(package:check_csnippets({test = [[
                struct lua_State;
                int luaopen_cjson(struct lua_State *L);
                int luaopen_cjson_safe(struct lua_State *L);
                void test(void) {
                    luaopen_cjson(0);
                    luaopen_cjson_safe(0);
                }
            ]]}))
        end
    end)
