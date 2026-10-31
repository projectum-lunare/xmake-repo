-- Projectum Lunare Xmake Repository - LuaSec Package
-- A binding for OpenSSL library to provide TLS/SSL communication over LuaSocket
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("luasec")
    set_homepage("https://github.com/lunarmodules/luasec")
    set_description("A binding for OpenSSL library to provide TLS/SSL communication over LuaSocket.")
    set_license("MIT")

    add_urls("https://github.com/lunarmodules/luasec/archive/refs/tags/v$(version).tar.gz")
    add_urls("https://github.com/lunarmodules/luasec.git")

    add_versions("1.3.2", "97293092ba385ab390decb6678bc8cbeffd5899bfbc49eb7ef4aa00f5e31c3d4")
    add_versions("1.3.1", "6fb919633a3304a262189f62a369adc4b36bc7113da37af093b069cf1c8d785e")
    add_versions("1.3.0", "daaa698504432ef2e3332590a4678fd741c2f92d405a1b119e375964eb59b1c3")
    add_versions("1.2.0", "2e86ef8f3486dc1bbecd752d16741a59a01633279facdfe5631f33b6eed1a30a")
    add_versions("1.1.0", "05995c993fcadffc91cf713b3467a674e1cffec7aed1467f4a189ca7feaa3b06")
    add_versions("1.0.2", "0001e24323beee51cd1ee186b369b50a19696d59960b537093883e5ce264d886")

    add_deps("lua")
    add_deps("openssl")
    add_deps("forge master", {kind = "addon"})

    if is_plat("windows", "mingw") then
        add_syslinks("ws2_32", "crypt32")
    end

    on_load(function (package)
        if package:config("shared") and package:is_plat("windows", "mingw", "linux", "macosx", "bsd", "haiku") then
            package:add("deps", "luasocket", {configs = {shared = true}})
        else
            package:add("deps", "luasocket")
        end
    end)

    on_install(function (package)
        local modname = package:config("shared") and "ssl" or "luasec"
        io.writefile("xmake.lua", string.format([[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            add_requires("openssl")
            includes("@addon/forge/forge.lua")

            target("%s")
                add_rules("forge.lua.module")
                add_packages("openssl")
                add_includedirs("src", "src/luasocket")
                add_defines("WITH_LUASOCKET", "LUASOCKET_DEBUG")
                add_files(
                    "src/options.c",
                    "src/config.c",
                    "src/ec.c",
                    "src/x509.c",
                    "src/context.c",
                    "src/ssl.c",
                    "src/luasocket/buffer.c",
                    "src/luasocket/io.c",
                    "src/luasocket/timeout.c"
                )
                if is_plat("windows", "mingw") then
                    add_files("src/luasocket/wsocket.c")
                    add_defines("WIN32", "NDEBUG", "_WINDOWS", "_USRDLL", "LSEC_EXPORTS", "BUFFER_DEBUG")
                    add_defines("LUASEC_INET_NTOP", "WINVER=0x0501", "_WIN32_WINNT=0x0501", "NTDDI_VERSION=0x05010300")
                    add_syslinks("ws2_32", "crypt32")
                else
                    add_files("src/luasocket/usocket.c")
                end
                add_files("src/ssl.lua")
                add_headerfiles("src/*.h", {prefixdir = "luasec"})

            target("ssl.https")
                add_rules("forge.lua.module")
                add_packages("lua")
                add_files("src/https.lua")
        ]], modname))
        import("@addon.forge.lua.module").install_project(package)
    end)

    on_test(function (package)
        if package:is_plat("linux", "macosx", "bsd") and not package:config("shared") then
            return
        end
        import("@addon.forge.lua.module").lua_test(package, [[
            local ssl = require("ssl")
            assert(ssl and ssl._VERSION)
            local https = require("ssl.https")
            assert(https and https.request)
        ]])
    end)
