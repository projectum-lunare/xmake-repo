-- Projectum Lunare Xmake Repository - BearSSL Package
-- Category: Cryptography & Security
-- Strict ANSI C89, ultra-lightweight SSL/TLS 1.2 implementation
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9

package("bearssl")
    set_homepage("https://bearssl.org/")
    set_description("BearSSL is an implementation of the SSL/TLS protocol (RFC 5246) written in strict C89.")
    set_license("MIT")

    add_urls("https://www.bearssl.org/bearssl-$(version).tar.gz")
    add_versions("0.6", "6705bba1714961b41a728dfc5debbe348d2966c117649392f8c8139efc83ff14")

    add_includedirs("include")

    on_install(function (package)
        local configs = {}
        io.writefile("xmake.lua", [[
            set_project("bearssl")
            set_version("0.6")
            set_languages("c89")
            add_rules("mode.release", "mode.debug")

            target("bearssl")
                set_kind("$(kind)")
                add_includedirs("inc", "src")
                add_headerfiles("inc/(bearssl*.h)", {prefixdir = "bearssl"})
                add_headerfiles("inc/(bearssl*.h)")
                add_files("src/**/*.c")
                add_defines("inline=__inline__")
                if is_plat("windows") then
                    add_syslinks("ws2_32")
                end
        ]])
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        if not package:is_cross() and not package:is_plat("wince", "dos", "os2", "amiga", "atari", "kolibri", "plan9") then
            assert(package:check_csnippets({test = [[
                #include <bearssl.h>
                void test(void) {
                    br_ssl_client_context cc;
                    (void)cc;
                }
            ]]}))
        end
    end)
