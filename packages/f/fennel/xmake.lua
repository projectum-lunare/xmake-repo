-- Projectum Lunare Xmake Repository - fennel Package
-- Category: Languages & Transpilers (Compile-to-Lua)
-- A lisp that compiles to Lua
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("fennel")
    set_homepage("https://fennel-lang.org")
    set_description("A lisp that compiles to Lua.")
    set_license("MIT")

    add_urls("https://git.sr.ht/~technomancy/fennel/archive/$(version).tar.gz")
    add_urls("https://git.sr.ht/~technomancy/fennel")

    add_versions("1.6.1", "f0f188e9a4424851d9263ab69302b6b2ffc5c6efb67a25fffc52187a29c94024")
    add_versions("1.6.0", "42942d90bbd68656b6025144bb0527c1ae5a5d55e22a53c7e820325230185bf5")

    add_bindirs("bin")

    on_load(function (package)
        import("@addon.recudo.lua.runtime").setup(package, {
            runtime = {"lua", "luajit"},
            default = "lua",
        })
    end)


    on_install(function (package)
        local lua = package:dep("lua")
        local lua_prog = lua:installdir("bin", is_host("windows") and "lua.exe" or "lua")
        if not os.isexec(lua_prog) then
            lua_prog = "lua"
        end

        local configs = {"build", LUA = lua_prog}
        import("package.tools.make").build(package, configs)

        os.mkdir("bin")
        os.cp("fennel", "bin/fennel")

        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            includes("@addon/recudo/recudo.lua")

            target("fennel")
                add_rules("recudo.lua.module")
                add_files("fennel.lua")

            target("fennel-bin")
                add_rules("recudo.lua.bin")
                add_files("bin/fennel")
        ]])
        import("@addon.recudo.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.recudo.lua.module").lua_test(package, "local fennel = require('fennel'); assert(fennel.eval('(+ 1 2)') == 3)")
        if not package:is_cross() then
            os.vrunv("fennel", {"--eval", "(+ 1 2)"})
        end
    end)
