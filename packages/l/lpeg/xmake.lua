-- Projectum Lunare Xmake Repository - LPeg Package
-- Category: Parsing, Data Formats & Templates
-- Parsing Expression Grammars for Lua
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("lpeg")
    set_homepage("https://www.inf.puc-rio.br/~roberto/lpeg/")
    set_description("Pattern-Matching for Lua that uses Parsing Expression Grammars (PEGs).")
    set_license("MIT")

    add_urls("https://www.inf.puc-rio.br/~roberto/lpeg/lpeg-$(version).tar.gz", {version = function (version)
        return version:sub(2)
    end})
    add_urls("https://github.com/roberto-ieru/LPeg.git")

    add_versions("v1.1.0", "4b155d67d2246c1ffa7ad7bc466c1ea899bbc40fef0257cc9c03cecbaed4352a")
    add_versions("v1.0.2", "48d66576051b6c78388faad09b70493093264588fcd0f258ddaab1cdd4a15ffe")

    on_load(function (package)
        import("@addon.recudo.lua.runtime").setup(package, {
            runtime = {"lua", "luajit"},
        })
    end)

    add_includedirs("include", "include/lpeg")

    on_install(function (package)
        io.writefile("xmake.lua", [[
            target("lpeg")
                add_rules("recudo.lua.module")
                add_files("lpcap.c", "lpcode.c", "lpcset.c", "lpprint.c", "lptree.c", "lpvm.c")
                add_headerfiles("*.h", {prefixdir = "lpeg"})
                add_headerfiles("*.h")

            target("re")
                add_rules("recudo.lua.module")
                add_files("re.lua")
        ]])
        import("@addon.recudo.lua.module").install_project(package)
    end)

    on_test(function (package)
        if not package:is_cross() and not package:is_plat("wince", "dos", "os2", "amiga", "atari", "kolibri", "plan9") then
            if package:config("shared") then
                import("@addon.recudo.lua.module").lua_test(package, "assert(require('lpeg'))")
            else
                assert(package:check_csnippets({test = [[
                    struct lua_State;
                    int luaopen_lpeg(struct lua_State *L);
                    void test(void) {
                        luaopen_lpeg(0);
                    }
                ]]}))
            end
        end
    end)
