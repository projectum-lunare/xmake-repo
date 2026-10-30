-- Projectum Lunare Xmake Repository - Solo Package
-- Physical I/O, System Foundations & Hardware Abstractions (C89 + Lua)
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9

package("solo")
    set_homepage("https://github.com/projectum-lunare/solo")
    set_description("Physical I/O, System Foundations & Hardware Abstractions")
    set_license("MPL-2.0")

    add_urls("/home/gustavo/Projetos/solo/.git")
    add_urls("https://github.com/projectum-lunare/solo.git")

    add_versions("master", "98bf73b224b64f25cfacccefc735101836a76762")

    add_deps("forge master", {kind = "addon"})
    if is_plat("linux", "macosx", "bsd", "windows", "mingw") then
        add_deps("lua >=5.4")
    end

    add_includedirs("include", "include/solo")

    on_install(function (package)
        import("@addon.forge.lua.module").install_project(package)
        os.tryrm(package:installdir("bin"))
    end)

    on_test(function (package)
        assert(package:check_csnippets({test = [[
            #include <solo/solo.h>
            void test(void) {
                const char *v = solo_version();
            }
        ]]}))

        if package:is_plat("linux", "macosx", "bsd", "windows", "mingw") then
            import("@addon.forge.lua.module").lua_test(package, "local solo = require('solo'); assert(solo.platform.os); local fs = require('solo.fs'); assert(fs.exists)")
        end
    end)
