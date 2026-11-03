-- Projectum Lunare Xmake Repository - rings Package
-- Category: Runtimes & Core Language
-- Multiple Lua states from Lua
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("rings")
    set_homepage("https://github.com/keplerproject/rings")
    set_description("Multiple Lua states from Lua.")
    set_license("MIT")

    add_urls("https://github.com/keplerproject/rings/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/keplerproject/rings.git")

    add_versions("v_1_3_0", "a1101c2fc8d5b943e66b70ce5d44d8a605567c98dc47fbdcb6722bdc81eabefe")


    add_includedirs("include", "include/rings")

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

            target("rings")
                add_rules("recudo.lua.module")
                add_files("src/rings.c")
                add_headerfiles("src/*.h", {prefixdir = "rings"})
                add_headerfiles("src/*.h")
        ]])
        import("@addon.recudo.lua.module").install_project(package)
    end)

    on_test(function (package)
        if package:config("shared") then
            import("@addon.recudo.lua.module").lua_test(package, "local rings = require('rings'); local env = rings.new(); local ok, res = env:dostring('return 42'); assert(ok and res == 42)")
        else
            assert(package:check_csnippets({test = [[
                struct lua_State;
                int luaopen_rings(struct lua_State *L);
                void test(void) {
                    luaopen_rings(0);
                }
            ]]}))
        end
    end)
