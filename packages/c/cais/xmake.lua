-- Projectum Lunare Xmake Repository - cais Package
-- Category: Physical I/O & System Foundations
-- Communication Abstraction & I/O Substrate with Lua bindings
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9

package("cais")
    set_homepage("https://github.com/projectum-lunare/cais")
    set_description("Communication Abstraction & I/O Substrate with Lua bindings for serial, parallel, socket, filesystem and sandboxing.")
    set_license("MPL-2.0")

    add_urls("https://github.com/projectum-lunare/cais.git")
    add_versions("0.2.0", "5b25ee177c43fb591aff6846af0c80616d669c27")

    on_load(function (package)
        import("@addon.recudo.lua.runtime").setup(package, {
            runtime = {"lua", "luajit"},
        })
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
            import("@addon.recudo.lua.module").lua_test(package, "assert(require('cais'))")
        end
    end)
