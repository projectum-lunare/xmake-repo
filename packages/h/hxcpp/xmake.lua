-- Projectum Lunare Xmake Repository - hxcpp Package
-- Category: Toolchains & Compilers
-- Runtime support and C++ backend for the Haxe compiler
-- Supported Platforms: Linux, macOS, Windows, BSD, Android, iOS, WASM

package("hxcpp")
    set_homepage("https://github.com/HaxeFoundation/hxcpp")
    set_description("Runtime support and C++ backend for the Haxe compiler.")
    set_license("Apache-2.0")

    add_urls("https://github.com/HaxeFoundation/hxcpp/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/HaxeFoundation/hxcpp.git")

    add_versions("v4.3.99", "0df6ecfee13f43b7230be1fda64892e6b9585e99d02693ff2bf6d9eb96b52907")
    add_versions("v4.3.98", "2d9d29ad43a32bbbbfb996609a4335b97ca6336b6be8d08d0f1be6c2506ec5a4")
    add_versions("v4.3.97", "194be83a7f9e47b1fe2af23b8d80a3fc103a12b668b1b34328abd27232a7a023")

    add_includedirs("include")
    add_links("hxcpp")

    if is_plat("linux", "bsd") then
        add_defines("HX_LINUX")
        add_syslinks("pthread", "dl")
    elseif is_plat("macosx") then
        add_defines("HX_MACOS")
    elseif is_plat("windows") then
        add_defines("HX_WINDOWS")
        add_syslinks("ws2_32")
    end

    if is_arch("x86_64", "arm64.*", "aarch64") then
        add_defines("HXCPP_M64")
    end

    on_load(function (package)
        package:addenv("PATH", "bin")
    end)

    on_install(function (package)
        io.writefile("xmake.lua", [[
            target("hxcpp")
                set_kind("$(kind)")
                set_languages("c++11")
                add_includedirs("include")

                if is_plat("linux", "bsd") then
                    add_defines("HX_LINUX")
                    add_syslinks("pthread", "dl")
                elseif is_plat("macosx") then
                    add_defines("HX_MACOS")
                elseif is_plat("windows") then
                    add_defines("HX_WINDOWS")
                    add_syslinks("ws2_32")
                end

                if is_arch("x86_64", "arm64.*", "aarch64") then
                    add_defines("HXCPP_M64")
                end

                if is_plat("linux", "macosx", "bsd") then
                    add_cxflags("-Wno-invalid-offsetof", "-Wno-overflow", "-frtti")
                end

                add_files(
                    "src/hx/Anon.cpp",
                    "src/hx/Boot.cpp",
                    "src/hx/CFFI.cpp",
                    "src/hx/Date.cpp",
                    "src/hx/gc/GcCommon.cpp",
                    "src/hx/gc/Immix.cpp",
                    "src/hx/gc/GcRegCapture.cpp",
                    "src/hx/Hash.cpp",
                    "src/hx/Lib.cpp",
                    "src/hx/Object.cpp",
                    "src/hx/StdLibs.cpp",
                    "src/hx/Debug.cpp",
                    "src/hx/Thread.cpp",
                    "src/Array.cpp",
                    "src/hx/Class.cpp",
                    "src/Dynamic.cpp",
                    "src/Enum.cpp",
                    "src/Math.cpp",
                    "src/String.cpp",
                    "src/hx/libs/std/Sys.cpp",
                    "src/hx/libs/std/File.cpp",
                    "src/hx/libs/std/Process.cpp",
                    "src/hx/libs/std/Socket.cpp",
                    "src/hx/libs/std/Random.cpp"
                )

                add_headerfiles("include/(**.h)")
        ]])

        import("package.tools.xmake").install(package)

        -- Provide haxelib path proxy script so haxe compiler can resolve hxcpp
        local bindir = package:installdir("bin")
        os.mkdir(bindir)
        if package:is_plat("windows") then
            local cmd_script = "@echo off\r\nif \"%1\"==\"path\" if \"%2\"==\"hxcpp\" (\r\n    echo %~dp0..\r\n    echo -D hxcpp=4.3.0\r\n    exit /b 0\r\n)\r\n"
            io.writefile(path.join(bindir, "haxelib.cmd"), cmd_script)
            io.writefile(path.join(bindir, "haxelib.bat"), cmd_script)
        else
            local sh_script = "#!/bin/sh\nif [ \"$1\" = \"path\" ] && [ \"$2\" = \"hxcpp\" ]; then\n    cd \"$(dirname \"$0\")/..\" && pwd\n    echo \"-D hxcpp=4.3.0\"\n    exit 0\nfi\n"
            local sh_file = path.join(bindir, "haxelib")
            io.writefile(sh_file, sh_script)
            if not is_host("windows") then
                os.runv("chmod", {"+x", sh_file})
            end
        end
    end)

    on_test(function (package)
        assert(package:has_cxxincludes("hxcpp.h"))
    end)
