-- Projectum Lunare Xmake Repository - eLua Package
-- Category: Runtimes & Core Language
-- Embedded Lua - Lua for microcontrollers (host tools, library, and runtime headers)
-- Supported Platforms: Linux, macOS, BSD, Windows

package("elua")
    set_homepage("https://github.com/elua/elua")
    set_description("Embedded Lua (eLua) offers the full implementation of the Lua language to the embedded world.")
    set_license("MIT")

    add_urls("https://github.com/elua/elua/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/elua/elua.git")

    add_versions("v0.9", "45a14d01441fe702c064ae6930e8514f26bec99eda7f6edbcfe1340366f57936")
    add_versions("v0.8", "523fba2a8f2a8bbc1d5d55d3a8451bba32edd401bcc2728b79ae34e1b02d1b4b")
    add_versions("v0.7", "8b520fa10a8fcfe4b2ff42811a841e06ee91b58e695f6f5a52ee19d08c2496c1")

    add_bindirs("bin")
    add_includedirs("include", "include/remotefs")

    on_install(function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")

            target("elua")
                set_kind("static")
                set_languages("gnu11")
                add_includedirs("inc", "inc/remotefs", "inc/desktop")
                add_files("src/eluarpc.c", "src/remotefs/remotefs.c")
                add_headerfiles("inc/*.h")
                add_headerfiles("inc/remotefs/*.h", {prefixdir = "remotefs"})
                add_headerfiles("inc/desktop/*.h")

            target("rfs_server")
                set_kind("binary")
                set_languages("gnu11")
                add_defines("RFS_STANDALONE_MODE")
                add_includedirs("rfs_server_src", "inc", "inc/remotefs", "inc/desktop")
                add_files(
                    "rfs_server_src/deskutils.c",
                    "rfs_server_src/log.c",
                    "rfs_server_src/main.c",
                    "rfs_server_src/rfs_transports.c",
                    "rfs_server_src/server.c"
                )
                add_deps("elua")
                if is_plat("windows") then
                    add_files("rfs_server_src/net_win32.c", "rfs_server_src/os_io_win32.c", "rfs_server_src/serial_win32.c")
                    add_syslinks("ws2_32")
                else
                    add_files("rfs_server_src/net_posix.c", "rfs_server_src/os_io_posix.c", "rfs_server_src/serial_posix.c")
                    add_syslinks("pthread")
                end

            target("mux")
                set_kind("binary")
                set_languages("gnu11")
                add_includedirs("mux_src", "rfs_server_src", "inc", "inc/remotefs", "inc/desktop")
                add_files(
                    "mux_src/main.c",
                    "rfs_server_src/deskutils.c",
                    "rfs_server_src/log.c",
                    "rfs_server_src/rfs_transports.c",
                    "rfs_server_src/server.c"
                )
                add_deps("elua")
                if is_plat("windows") then
                    add_files("rfs_server_src/net_win32.c", "rfs_server_src/os_io_win32.c", "rfs_server_src/serial_win32.c")
                    add_syslinks("ws2_32")
                else
                    add_files("rfs_server_src/net_posix.c", "rfs_server_src/os_io_posix.c", "rfs_server_src/serial_posix.c")
                    add_syslinks("pthread")
                end
        ]])
        import("package.tools.xmake").install(package)
        os.cp("mkfs.py", package:installdir("bin"))
        os.cp("cross-lua.py", package:installdir("bin"))
    end)

    on_test(function (package)
        assert(package:has_cincludes("eluarpc.h"))
        assert(package:has_cincludes("remotefs/remotefs.h"))
        try
        {
            function ()
                os.vrun("rfs_server")
            end,
            catch
            {
                function (errors)
                    assert(tostring(errors):find("rfs_server", 1, true) or tostring(errors):find("Usage", 1, true))
                end
            }
        }
    end)
