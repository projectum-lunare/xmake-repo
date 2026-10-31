-- Projectum Lunare Xmake Repository - LuaSocket Package
-- Category: Networking, Web & Services
-- Network support for the Lua language
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("luasocket")
    set_homepage("https://github.com/lunarmodules/luasocket")
    set_description("Network support for the Lua language.")
    set_license("MIT")

    add_urls("https://github.com/lunarmodules/luasocket/archive/refs/tags/v$(version).tar.gz")
    add_urls("https://github.com/lunarmodules/luasocket.git")

    add_versions("3.1.0", "bf033aeb9e62bcaa8d007df68c119c966418e8c9ef7e4f2d7e96bddeca9cca6e")
    add_versions("3.0.0", "04d98e40edcee7c7c5f83f0e8ba5503d14b56280e20daceee9e34ed7cf8f1b15")

    add_deps("lua")
    add_deps("forge master", {kind = "addon"})

    add_includedirs("include", "include/luasocket")

    if is_plat("windows", "mingw") then
        add_syslinks("ws2_32")
    elseif is_plat("haiku") then
        add_syslinks("network")
    end

    on_install(function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            includes("@addon/forge/forge.lua")

            target("socket.core")
                add_rules("forge.lua.module")
                add_includedirs("src")
                add_defines("LUASOCKET_DEBUG")
                add_files(
                    "src/luasocket.c",
                    "src/timeout.c",
                    "src/buffer.c",
                    "src/io.c",
                    "src/auxiliar.c",
                    "src/options.c",
                    "src/inet.c",
                    "src/except.c",
                    "src/select.c",
                    "src/tcp.c",
                    "src/udp.c",
                    "src/compat.c"
                )
                if is_plat("windows", "mingw") then
                    add_files("src/wsocket.c")
                    add_syslinks("ws2_32")
                    add_defines("WINVER=0x0501", "_CRT_SECURE_NO_WARNINGS")
                else
                    add_files("src/usocket.c")
                    if is_plat("macosx") then
                        add_defines("UNIX_HAS_SUN_LEN")
                    elseif is_plat("haiku") then
                        add_syslinks("network")
                    end
                end
                add_headerfiles("src/*.h", {prefixdir = "luasocket"})
                add_headerfiles("src/*.h")

            target("mime.core")
                add_rules("forge.lua.module")
                add_includedirs("src")
                add_defines("LUASOCKET_DEBUG")
                add_files("src/mime.c", "src/compat.c")

            if not is_plat("windows", "mingw") then
                target("socket.unix")
                    add_rules("forge.lua.module")
                    add_includedirs("src")
                    add_defines("LUASOCKET_DEBUG")
                    add_files(
                        "src/buffer.c",
                        "src/compat.c",
                        "src/auxiliar.c",
                        "src/options.c",
                        "src/timeout.c",
                        "src/io.c",
                        "src/usocket.c",
                        "src/unix.c",
                        "src/unixdgram.c",
                        "src/unixstream.c"
                    )
                    if is_plat("macosx") then
                        add_defines("UNIX_HAS_SUN_LEN")
                    end

                target("socket.serial")
                    add_rules("forge.lua.module")
                    add_includedirs("src")
                    add_defines("LUASOCKET_DEBUG")
                    add_files(
                        "src/buffer.c",
                        "src/compat.c",
                        "src/auxiliar.c",
                        "src/options.c",
                        "src/timeout.c",
                        "src/io.c",
                        "src/usocket.c",
                        "src/serial.c"
                    )
            end

            for _, mod in ipairs({
                {name = "socket",         file = "src/socket.lua"},
                {name = "mime",           file = "src/mime.lua"},
                {name = "ltn12",          file = "src/ltn12.lua"},
                {name = "socket.http",    file = "src/http.lua"},
                {name = "socket.url",     file = "src/url.lua"},
                {name = "socket.tp",      file = "src/tp.lua"},
                {name = "socket.ftp",     file = "src/ftp.lua"},
                {name = "socket.headers", file = "src/headers.lua"},
                {name = "socket.smtp",    file = "src/smtp.lua"},
            }) do
                target(mod.name)
                    add_rules("forge.lua.module")
                    add_packages("lua")
                    add_files(mod.file)
            end
        ]])
        import("@addon.forge.lua.module").install_project(package)
    end)

    on_test(function (package)
        if package:config("shared") then
            import("@addon.forge.lua.module").lua_test(package, [[
                local socket = require("socket")
                local mime = require("mime")
                local ltn12 = require("ltn12")
                local url = require("socket.url")
                local http = require("socket.http")
                assert(socket and socket._VERSION)
                assert(mime and mime._VERSION)
                assert(type(socket.gettime()) == "number")
            ]])
        else
            assert(package:check_csnippets({test = [[
                struct lua_State;
                int luaopen_socket_core(struct lua_State *L);
                int luaopen_mime_core(struct lua_State *L);
                void test(void) {
                    luaopen_socket_core(0);
                    luaopen_mime_core(0);
                }
            ]]}))
        end
    end)
