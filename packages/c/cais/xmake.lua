-- Projectum Lunare Xmake Repository - cais Package
-- Category: Physical I/O & System Foundations
-- Communication Abstraction & I/O Substrate with Lua bindings
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9

package("cais")
    set_homepage("https://github.com/projectum-lunare/cais")
    set_description("Communication Abstraction & I/O Substrate with Lua bindings for serial, parallel, socket, filesystem, sandboxing, and Noise transport.")
    set_license("MPL-2.0")

    add_urls("https://github.com/projectum-lunare/cais/archive/refs/tags/v$(version).tar.gz")
    add_urls("https://github.com/projectum-lunare/cais.git")
    add_versions("0.3.1", "72c528c543559a563979066082a41fc488326164df5d1e51069c01d4cca0c977")
    add_versions("0.3.0", "7857c8d061bf1e8f8a31b25d313939b7743bc064ad6acae04431c2c65239c36a")
    add_versions("0.2.0", "f9100f86fb0d2a6359b6e45daac8e1c25e6c56e6")

    -- Optional language bindings
    add_configs("lua",        {description = "Build Lua C bindings and runtime modules", default = true, type = "boolean"})

    -- Modular subsystem configurations
    add_configs("filesystem", {description = "Enable filesystem and path I/O subsystem", default = true, type = "boolean"})
    add_configs("socket",     {description = "Enable raw TCP/UDP socket subsystem", default = true, type = "boolean"})
    add_configs("serial",     {description = "Enable RS-232 serial UART driver", default = true, type = "boolean"})
    add_configs("parallel",   {description = "Enable IEEE 1284 parallel port driver", default = true, type = "boolean"})
    add_configs("sandbox",    {description = "Enable kernel security sandboxing", default = true, type = "boolean"})
    add_configs("noise",      {description = "Enable Noise cryptographic transport subsystem", default = true, type = "boolean"})

    on_load(function (package)
        if package:config("lua") then
            package:add("deps", "lua >=5.4")
        end

        if package:config("noise") then
            package:add("deps", "monocypher", {configs = {shared = false}})
            package:add("deps", "blake2", {configs = {shared = false}})
        end

        -- Link surface: the shared variant ships loadable modules (only the
        -- C core is -l-linkable); the static variant ships embedding archives
        -- (the umbrella bindings plus the C core; the consumer brings Lua).
        -- When lua is disabled, only the pure C core archive (libcais) is linked.
        if package:config("lua") then
            if package:config("shared") then
                package:add("links", "cais")
            else
                package:add("links", "cais_lua", "cais")
            end
        else
            package:add("links", "cais")
        end
    end)

    on_install(function (package)
        local configs = {}
        for _, name in ipairs({"lua", "filesystem", "socket", "serial", "parallel", "sandbox", "noise"}) do
            configs[name] = package:config(name)
        end
        import("package.tools.xmake").install(package, configs)

        if package:config("lua") then
            import("@addon.recudo.lua.tree").apply_search_envs(package)
        end
    end)

    on_test(function (package)
        if not package:is_cross() and not package:is_plat("wince", "dos", "os2", "amiga", "atari", "kolibri", "plan9") then
            if package:config("lua") then
                if package:config("shared") then
                    import("@addon.recudo.lua.recipe").lua_test(package, "assert(require('cais'))")
                else
                    assert(package:check_csnippets({test = [[
                        struct lua_State;
                        int luaopen_cais(struct lua_State *L);
                        void test(void) {
                            luaopen_cais(0);
                        }
                    ]]}))
                end
            else
                assert(package:check_csnippets({test = [[
                    #include <cais/cais.h>
                    void test(void) {
                        const char *v = cais_version();
                        (void)v;
                    }
                ]]}))
            end
        end
    end)
