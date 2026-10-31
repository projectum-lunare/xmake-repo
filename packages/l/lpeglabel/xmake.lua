-- Projectum Lunare Xmake Repository - lpeglabel Package
-- Parsing Expression Grammars For Lua with Labeled Failures
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("lpeglabel")
    set_homepage("https://github.com/sqmedeiros/lpeglabel")
    set_description("Parsing Expression Grammars For Lua with Labeled Failures.")
    set_license("MIT")

    add_urls("https://github.com/sqmedeiros/lpeglabel/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/sqmedeiros/lpeglabel.git")

    add_versions("v1.6.2-1", "5511d2704de4580c5b79b100c2daec5e773db58be9c2239e49ea2d9da2decf67")
    add_versions("v1.6.1-1", "8ae6b44b789d8c1dfbca1ca684308c47657fb0f5f4e7f6ee770147d27c25d1d7")

    add_deps("lua")
    add_deps("forge master", {kind = "addon"})

    add_includedirs("include", "include/lpeglabel")

    on_install(function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            includes("@addon/forge/forge.lua")

            target("lpeglabel")
                add_rules("forge.lua.module")
                add_files("lplcap.c", "lplcode.c", "lplprint.c", "lpltree.c", "lplvm.c")
                add_headerfiles("*.h", {prefixdir = "lpeglabel"})
                add_headerfiles("*.h")

            target("relabel")
                add_rules("forge.lua.module")
                add_files("relabel.lua")
        ]])
        import("@addon.forge.lua.module").install_project(package)
    end)

    on_test(function (package)
        if package:config("shared") then
            import("@addon.forge.lua.module").lua_test(package, "assert(require('lpeglabel')); assert(require('relabel'))")
        else
            assert(package:check_csnippets({test = [[
                struct lua_State;
                int luaopen_lpeglabel(struct lua_State *L);
                void test(void) {
                    luaopen_lpeglabel(0);
                }
            ]]}))
        end
    end)
