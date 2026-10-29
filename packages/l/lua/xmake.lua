-- Projectum Lunare Xmake Repository - Lua Package
-- Enhanced with retro-computing, embedded and C89 patches
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("lua")
    set_homepage("https://lua.org/")
    set_description("A powerful, efficient, lightweight, embeddable scripting language.")
    set_license("MIT")

    add_urls("https://www.lua.org/ftp/lua-$(version).tar.gz", {version = function (version)
        return version:sub(2)
    end})
    add_urls("https://github.com/lua/lua.git")

    add_versions("v5.5.1", "1c4b4068d67061f2a2231ad2b5422e77acea1487ea9890f6320af614f4373dce")
    add_versions("v5.5.0", "57ccc32bbbd005cab75bcc52444052535af691789dba2b9016d5c50640d68b3d")
    add_versions("v5.4.8", "4f18ddae154e793e46eeab727c59ef1c0c0c2b744e7b94219710d76f530629ae")
    add_versions("v5.4.7", "9fbf5e28ef86c69858f6d3d34eccc32e911c1a28b4120ff3e84aaa70cfbf1e30")
    add_versions("v5.4.6", "7d5ea1b9cb6aa0b59ca3dde1c6adcb57ef83a1ba8e5432c0ecd06bf439b3ad88")
    add_versions("v5.4.4", "164c7849653b80ae67bec4b7473b884bf5cc8d2dca05653475ec2ed27b9ebf61")

    -- Retro & Embedded Patches from Projectum Lunare
    if is_plat("wince") then
        add_patches(">=5.4.0", "patches/wince.patch")
    elseif is_plat("kolibri") then
        add_patches(">=5.4.0", "patches/kolibri.patch")
    elseif is_plat("plan9") then
        add_patches(">=5.4.0", "patches/plan9.patch")
    elseif is_plat("wasm", "wasi") then
        add_patches(">=5.4.0", "patches/wasm.patch")
    end

    add_configs("c89",       {description = "Compile in strict ANSI C89 mode (LUA_USE_C89)", type = "boolean"})
    add_configs("32bits",    {description = "Enable 32-bit integers and floats (LUA_32BITS)", type = "boolean"})
    add_configs("no_parser", {description = "Disable compiler/parser (undump bytecode runtime only)", default = false, type = "boolean"})

    add_includedirs("include", "include/lua")
    if not is_plat("windows", "mingw", "wince", "dos", "kolibri", "wasm", "wasi") then
        add_syslinks("dl", "m")
    end

    on_load(function (package)
        package:addenv("PATH", "bin")
    end)

    on_install(function (package)
        local sourcedir = os.isdir("src") and "src/" or ""
        local use_c89 = package:config("c89")
        if use_c89 == nil then
            use_c89 = package:is_plat("wince", "dos", "os2", "amiga", "atari", "kolibri", "plan9")
        end

        local use_32b = package:config("32bits")
        if use_32b == nil then
            use_32b = package:is_plat("wince", "dos", "os2", "amiga", "atari", "kolibri", "plan9")
                   or package:is_arch("m68k.*", "i386", "x86", "mips.*", "ppc.*", "powerpc", "armv4.*", "armv5.*", "sh.*")
        end
        local no_parser = package:config("no_parser")

        io.writefile("xmake.lua", format([[
            add_rules("mode.release", "mode.debug")

            local sourcedir = "%s"
            target("lualib")
                set_kind("%s")
                set_basename("lua")
                add_headerfiles(sourcedir .. "*.h", {prefixdir = "lua"})
                add_headerfiles(sourcedir .. "*.h")
                add_headerfiles(sourcedir .. "lua.hpp", {prefixdir = "lua"})
                add_files(sourcedir .. "*.c|lua.c|luac.c|onelua.c%s")
                add_defines("LUA_COMPAT_5_3")

                %s
                %s
                %s

                if is_plat("linux", "bsd", "cross") then
                    add_defines("LUA_USE_LINUX", "LUA_DL_DLOPEN")
                elseif is_plat("macosx", "iphoneos") then
                    add_defines("LUA_USE_MACOSX", "LUA_DL_DYLD")
                elseif is_plat("windows", "mingw") then
                    if is_kind("shared") then
                        add_defines("LUA_BUILD_AS_DLL", {public = true})
                    end
                elseif is_plat("wince") then
                    add_defines("UNDER_CE=300", "_WIN32_WCE=300")
                    add_includedirs(sourcedir .. "compat/wince")
                    add_files(sourcedir .. "compat/wince/*.c|wince_main.c")
                elseif is_plat("kolibri") then
                    add_defines("__KOLIBRIOS__")
                elseif is_plat("plan9") then
                    add_defines("_POSIX_SOURCE", "_PLAN9_SOURCE", "_BSD_EXTENSION")
                elseif is_plat("wasm", "wasi") then
                    add_defines("_WASI_EMULATED_SIGNAL", "_WASI_EMULATED_PROCESS_CLOCKS")
                end

            target("lua")
                set_enabled(%s)
                set_kind("binary")
                add_files(sourcedir .. "lua.c")
                add_deps("lualib")
                if not is_plat("windows", "mingw", "wince", "dos", "kolibri", "wasm", "wasi") then
                    add_syslinks("dl")
                end
        ]],
            sourcedir,
            package:config("shared") and "shared" or "static",
            no_parser and "|lcode.c|llex.c|lparser.c" or "",
            use_c89 and 'add_defines("LUA_USE_C89")' or "",
            use_32b and 'add_defines("LUA_32BITS")' or "",
            no_parser and 'add_defines("LUA_NO_PARSER")' or "",
            (package:is_cross() or no_parser or package:is_plat("wasm", "wasi")) and "false" or "true"))

        local configs = {}
        if package:config("shared") then
            configs.kind = "shared"
        end

        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        if not package:is_cross() and not package:config("no_parser") and not package:is_plat("wasm", "wasi") then
            os.vrun("lua -e \"print('Projectum Lunare Lua ready!')\"")
        end
        assert(package:has_cfuncs("lua_getinfo", {includes = "lua.h"}))
    end)
