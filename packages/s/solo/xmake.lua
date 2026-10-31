-- Projectum Lunare Xmake Repository - Solo Package
-- Category: System, Hardware & Native Bindings
-- Physical I/O, System Foundations & Hardware Abstractions (C89 + Lua)
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9

package("solo")
    set_homepage("https://github.com/projectum-lunare/solo")
    set_description("Physical I/O, System Foundations & Hardware Abstractions")
    set_license("MPL-2.0")

    add_urls("https://github.com/projectum-lunare/solo/archive/refs/tags/v$(version).tar.gz")
    add_urls("https://github.com/projectum-lunare/solo.git")

    add_versions("0.2.0", "d6a245acccc8a5567a9cba4e9450d4cdf04e1f57bcf786a10ac8f8e18da8cabc")
    add_versions("0.1.0", "36cb5330426814e6b74d4a676a7d16c0f63692f3c99a92f7a3408e845ed4eb3c")
    add_versions("master", "888638aaee24224ccbef156ae3b2b67ced42f805")

    add_deps("forge master", {kind = "addon"})
    if is_plat("linux", "macosx", "bsd", "windows", "mingw") then
        add_deps("lua >=5.4")
    end

    add_includedirs("include", "include/solo")

    on_install(function (package)
        io.gsub("xmake.lua", 'add_addons%("forge master"%)', "")
        io.gsub("xmake.lua", 'add_repositories%("projectum%-lunare.-"%)', "")
        import("@addon.forge.lua.module").install_project(package)
        os.tryrm(package:installdir("bin"))
    end)

    on_test(function (package)
        assert(package:has_cincludes("solo/solo.h"))
        if package:is_plat("linux", "macosx", "bsd", "windows", "mingw") then
            import("@addon.forge.lua.module").lua_test(package, "local solo = require('solo'); assert(solo.platform.os); local fs = require('solo.fs'); assert(fs.exists)")
        end
    end)
