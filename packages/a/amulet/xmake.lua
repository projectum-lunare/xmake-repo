-- Projectum Lunare Xmake Repository - amulet
-- Category: Game Engines & Creative Coding

package("amulet")
    set_kind("binary")
    set_homepage("http://www.amulet.xyz/")
    set_description("A Lua-based audio/visual game toolkit for small games, rapid prototyping and experimentation.")
    set_license("MIT")

    add_urls("https://github.com/ianmaclarty/amulet/archive/refs/tags/$(version).tar.gz")
    add_versions("v1.9.4", "fe11273c035e81e447c27382bfb1e6499c246eb9758f6613ab64eeb5ec15feb1")
    add_versions("v1.9.3", "3c49544ca9ad351012e934d9eeedbef3717a7a71748978ab93ca13290dcdf3fd")

    add_deps("libsdl2")

    on_load(function (package)
        package:addenv("PATH", "bin")
    end)

    on_install("linux", "macosx", function (package)
        local target_plat = "linux64"
        if package:is_plat("linux") then
            target_plat = package:is_arch("x86_64") and "linux64" or "linux32"
        elseif package:is_plat("macosx") then
            target_plat = "osx"
        end

        local grade = package:is_debug() and "debug" or "release"
        local luavm = "lua51"
        local build_dir = path.join("builds", target_plat, luavm, grade)
        local build_lib_dir = path.join(build_dir, "lib")
        local build_inc_dir = path.join(build_dir, "include")
        local build_bin_dir = path.join(build_dir, "bin")

        os.mkdir(build_lib_dir)
        os.mkdir(build_inc_dir)

        -- Copy SDL2 headers from dependency or system
        local libsdl2 = package:dep("libsdl2")
        local fetchinfo = libsdl2 and libsdl2:fetch()
        if fetchinfo and fetchinfo.includedirs then
            for _, incdir in ipairs(fetchinfo.includedirs) do
                if os.isdir(incdir) then
                    os.cp(path.join(incdir, "*"), build_inc_dir)
                end
            end
        elseif libsdl2 and not libsdl2:is_system() then
            local incdir = libsdl2:installdir("include")
            if os.isdir(incdir) then
                os.cp(path.join(incdir, "*"), build_inc_dir)
            end
        end
        if os.isdir("/usr/include/SDL2") then
            os.cp("/usr/include/SDL2/*", build_inc_dir)
        end

        -- Provide stub archive so Makefile skips the outdated bundled SDL2 snapshot
        os.vrunv("ar", {"rcus", path.join(build_lib_dir, "libsdl.a")})

        local ldflags = "-lSDL2 -ldl -lm -lrt -pthread"
        if fetchinfo and fetchinfo.linkdirs then
            for _, linkdir in ipairs(fetchinfo.linkdirs) do
                ldflags = "-L" .. linkdir .. " " .. ldflags
            end
        end

        local argv = {
            "-j" .. tostring(os.default_njob()),
            "TARGET=" .. target_plat .. "." .. grade,
            "LUAVM=" .. luavm,
            "XCFLAGS=-Wall -pthread -fno-strict-aliasing -Wno-error",
            "XLDFLAGS=" .. ldflags
        }

        os.vrunv("make", argv)

        local exe = "amulet"
        os.mkdir(package:installdir("bin"))
        os.cp(path.join(build_bin_dir, exe), package:installdir("bin"))
        os.tryrm("amulet")
    end)

    on_test(function (package)
        if not package:is_cross() then
            local out = os.iorunv("amulet", {"version"})
            assert(out and out:find("Amulet", 1, true), "unexpected version: " .. tostring(out))
        end
    end)
