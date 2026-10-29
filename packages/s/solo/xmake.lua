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

    add_deps("forge", {kind = "addon"})
    if is_plat("linux", "macosx", "bsd", "windows", "mingw") then
        add_deps("lua >=5.4")
    end

    add_includedirs("include", "include/solo")

    on_load(function (package)
        local ext = package:is_plat("windows", "mingw") and ".dll" or ".so"
        package:addenv("LUA_CPATH", "lib/?" .. ext)
        package:mark_as_pathenv("LUA_CPATH")
    end)

    on_install(function (package)
        local configs = {}
        import("package.tools.xmake").install(package, configs)

        -- Remove bogus libsolo.so (which is the Lua module solo.so) so the C linker uses libsolo.a
        os.tryrm(package:installdir("lib/libsolo.so"))
        os.tryrm(package:installdir("lib/libsolo_lua_static.a"))

        -- Install standalone submodules into lib/solo/ for Lua require("solo.<submodule>")
        if os.isdir("build/lua/solo") then
            os.cp("build/lua/solo", package:installdir("lib"))
        end

        -- Clean up flat duplicate submodule libraries from lib root
        for _, mod in ipairs({"platform", "filesystem", "fs", "parallel", "serial", "socket", "sandbox"}) do
            os.tryrm(package:installdir("lib/" .. mod .. ".so"))
            os.tryrm(package:installdir("lib/" .. mod .. ".dll"))
        end

        os.tryrm(package:installdir("bin"))
    end)

    on_test(function (package)
        assert(package:check_csnippets({test = [[
            #include <solo/solo.h>
            void test(void) {
                const char *v = solo_version();
            }
        ]]}))

        if not package:is_cross() and (package:is_plat("linux", "macosx", "bsd", "windows", "mingw")) then
            local envs = {}
            local lua_cpath = os.getenv("LUA_CPATH")
            if lua_cpath then
                if not package:is_plat("windows") and not package:is_plat("mingw") then
                    lua_cpath = lua_cpath:gsub(":", ";")
                end
                if not lua_cpath:endswith(";;") then
                    lua_cpath = lua_cpath .. ";;"
                end
                envs.LUA_CPATH = lua_cpath
            end
            os.vrunv("lua", {"-e", "local solo = require('solo'); assert(solo.platform.os); local fs = require('solo.fs'); assert(fs.exists)"}, {envs = envs})
        end
    end)
