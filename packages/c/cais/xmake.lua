-- Projectum Lunare Xmake Repository - cais Package
-- Category: Physical I/O & System Foundations
-- Communication Abstraction & I/O Substrate with Lua bindings
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9

package("cais")
    set_homepage("https://github.com/projectum-lunare/cais")
    set_description("Communication Abstraction & I/O Substrate with Lua bindings for serial, parallel, socket, filesystem and sandboxing.")
    set_license("MPL-2.0")

    add_urls("https://github.com/projectum-lunare/cais.git")
    add_versions("0.2.0", "f9100f86fb0d2a6359b6e45daac8e1c25e6c56e6")
    add_versions("0.3.0", "v0.3.0")

    on_load(function (package)
        import("@addon.recudo.lua.runtime").setup(package, {
            runtime = {"lua", "luajit"},
        })
        -- Link surface: the shared variant ships loadable modules (only the
        -- C core is -l-linkable); the static variant ships embedding archives
        -- (the umbrella bindings plus the C core; the consumer brings Lua).
        if package:config("shared") then
            package:add("links", "cais")
        else
            package:add("links", "cais_lua", "cais")
        end
    end)

    on_install(function (package)
        -- Uses the cais project's own xmake.lua: install_project() strips the
        -- addon/repository declarations, injects the recudo environment and
        -- installs the default targets (Lua umbrella + standalone submodules,
        -- plus libcais.a and the public C headers for native consumers).
        import("@addon.recudo.lua.module").install_project(package)
    end)

    on_test(function (package)
        if not package:is_cross() and not package:is_plat("wince", "dos", "os2", "amiga", "atari", "kolibri", "plan9") then
            if package:config("shared") then
                import("@addon.recudo.lua.module").lua_test(package, "assert(require('cais'))")
            else
                -- Static variant: no loadable modules are installed. Verify
                -- the embedding path instead (the archive resolves the
                -- umbrella opener).
                assert(package:check_csnippets({test = [[
                    struct lua_State;
                    int luaopen_cais(struct lua_State *L);
                    void test(void) {
                        luaopen_cais(0);
                    }
                ]]}))
            end
        end
    end)
