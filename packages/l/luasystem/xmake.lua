-- Projectum Lunare Xmake Repository - luasystem Package
-- Category: System, Hardware & Native Bindings
-- Platform independent system calls for Lua
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("luasystem")
    set_homepage("https://github.com/lunarmodules/luasystem")
    set_description("Platform independent system calls for Lua.")
    set_license("MIT")

    add_urls("https://github.com/lunarmodules/luasystem/archive/refs/tags/v$(version).tar.gz")
    add_urls("https://github.com/lunarmodules/luasystem.git")

    add_versions("0.7.1", "c85fb1e05ba5059a767ee0f6c8db8b9a30b86760224085b687ffbdf4892895cd")
    add_versions("0.7.0", "f6a617414f5e27c69e2377c7e2b90631b8ee0529c3ef7960d6937e33247d0bbe")


    if is_plat("windows", "mingw") then
        add_syslinks("advapi32", "winmm", "bcrypt")
    elseif is_plat("linux") then
        add_syslinks("rt")
    end

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

            target("system.core")
                add_rules("recudo.lua.module")
                add_packages("lua")
                add_includedirs("src")
                add_files(
                    "src/core.c",
                    "src/compat.c",
                    "src/time.c",
                    "src/environment.c",
                    "src/random.c",
                    "src/term.c",
                    "src/bitflags.c",
                    "src/wcwidth.c"
                )
                if is_plat("windows", "mingw") then
                    add_defines("WINVER=0x0600", "_WIN32_WINNT=0x0600")
                    add_syslinks("advapi32", "winmm", "bcrypt")
                elseif is_plat("linux") then
                    add_syslinks("rt")
                end

            target("system")
                add_rules("recudo.lua.module")
                add_packages("lua")
                add_files("system/init.lua")
        ]])
        import("@addon.recudo.lua.module").install_project(package)
    end)

    on_test(function (package)
        if package:is_plat("linux", "macosx", "bsd") and not package:config("shared") then
            -- Lua modules built statically cannot be dlopen'd by standalone lua
            return
        end
        import("@addon.recudo.lua.module").lua_test(package, [[
            local sys = require("system")
            assert(sys and sys.gettime)
            assert(type(sys.gettime()) == "number")
        ]])
    end)
