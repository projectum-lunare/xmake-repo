-- Projectum Lunare Xmake Repository - luautf8 Package
-- Category: Languages, Encodings & String Processing
-- A UTF-8 support module for Lua, compatible with Lua string module
-- Supported Platforms: Linux, macOS, Windows, BSD, Haiku, WASM

package("luautf8")
    set_homepage("https://github.com/starwing/luautf8")
    set_description("A UTF-8 support module for Lua, compatible with Lua string module.")
    set_license("MIT")

    add_urls("https://github.com/starwing/luautf8/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/starwing/luautf8.git")

    add_versions("0.2.1", "ea52075cd960aed8c37512ab31cdc166aa77a6458504d29f33ae40b93d2d8594")
    add_versions("0.2.0", "f79c11d994b86864f5c6c5326dcaede2b10c37303d664c1010705c3d2e23b232")
    add_versions("0.1.7", "fc55a33c35b052e762fd66891d53184ac4d20b24dde258e43ca943318a9a19bb")
    add_versions("0.1.6", "b76873b4afb09abd00508a66887ae1658492078869f9414c334dea35b5769656")

    on_load(function (package)
        import("@addon.recudo.lua.runtime").setup(package, {
            runtime = {"lua", "luajit"},
        })
    end)

    on_install(function (package)
        io.writefile("compat_export.c", [[
            #include <lua.h>
            #include <lauxlib.h>
            #if defined(_WIN32)
            __declspec(dllexport)
            #endif
            int luaopen_utf8(lua_State *L);
            #if defined(_WIN32)
            __declspec(dllexport)
            #endif
            int luaopen_lua_utf8(lua_State *L) {
                return luaopen_utf8(L);
            }
        ]])

        io.writefile("xmake.lua", [[
            target("lua-utf8")
                add_rules("recudo.lua.module")
                add_files("lutf8lib.c", "compat_export.c")
        ]])
        import("@addon.recudo.lua.module").install_project(package)
    end)

    on_test(function (package)
        if package:is_plat("linux", "macosx", "bsd") and not package:config("shared") then
            return
        end
        import("@addon.recudo.lua.module").lua_test(package, [[
            local utf8 = require("lua-utf8")
            assert(utf8 and type(utf8.len) == "function")
            assert(utf8.len("olá mundo") == 9)
        ]])
    end)
