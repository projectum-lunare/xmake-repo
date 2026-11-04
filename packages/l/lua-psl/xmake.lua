-- Projectum Lunare Xmake Repository - lua-psl Package
-- Category: Networking, Web & Services
-- Lua bindings to libpsl, a C library that handles the Public Suffix List (PSL)
-- Supported Platforms: Linux, macOS, BSD, Haiku

package("lua-psl")
    set_homepage("https://github.com/daurnimator/lua-psl")
    set_description("Lua bindings to libpsl, a C library that handles the Public Suffix List (PSL).")
    set_license("MIT")

    add_urls("https://github.com/daurnimator/lua-psl/archive/refs/tags/v$(version).tar.gz")
    add_urls("https://github.com/daurnimator/lua-psl.git")

    add_versions("0.3", "c7d529d33fcd9d898668014d174ed1dc1257e9076da98729d94a4e8b8d231d40")

    add_syslinks("psl")

    on_load(function (package)
        import("@addon.recudo.lua.runtime").setup(package, {
            runtime = {"lua", "luajit"},
            default = "lua",
            version = ">=5.1 <=5.4",
        })
    end)

    on_install(function (package)
        io.writefile("xmake.lua", [[
            target("psl")
                add_rules("recudo.lua.module")
                add_syslinks("psl")
                add_files("psl/psl.c")
        ]])
        import("@addon.recudo.lua.module").install_project(package)
    end)

    on_test(function (package)
        if package:config("shared") then
            import("@addon.recudo.lua.module").lua_test(package, [[
                local psl = require("psl")
                assert(psl)
                local p = psl.builtin() or psl.latest()
                assert(p)
                assert(p:is_public_suffix("com") == true)
            ]])
        end
    end)
