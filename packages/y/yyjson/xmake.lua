-- Projectum Lunare Xmake Repository - yyjson Package
-- Category: Parsing, Data Formats & Templates
-- The fastest JSON library in C
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("yyjson")
    set_homepage("https://github.com/ibireme/yyjson")
    set_description("The fastest JSON library in C.")
    set_license("MIT")

    add_urls("https://github.com/ibireme/yyjson/archive/refs/tags/$(version).tar.gz",
             "https://github.com/ibireme/yyjson.git")

    add_versions("0.13.0", "34e0f62a2bc11ab20d601e8ca1cc2b2079503aa45119a19133d89d19b94a0fae")
    add_versions("0.12.0", "b16246f617b2a136c78d73e5e2647c6f1de1313e46678062985bdcf1f40bb75d")
    add_versions("0.11.1", "610a38a5e59192063f5f581ce0c3c1869971c458ea11b58dfe00d1c8269e255d")
    add_versions("0.10.0", "0d901cb2c45c5586e3f3a4245e58c2252d6b24bf4b402723f6179523d389b165")

    if is_plat("windows") and is_kind("shared") then
        add_defines("YYJSON_IMPORTS")
    end

    on_install(function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.debug", "mode.release")
            target("yyjson")
                set_kind("$(kind)")
                add_files("src/*.c")
                add_headerfiles("src/*.h")
                if is_kind("shared") and is_plat("windows") then
                    add_defines("YYJSON_EXPORTS")
                end
        ]])
        import("package.tools.xmake").install(package)
    end)

    on_test(function (package)
        assert(package:has_cincludes("yyjson.h"))
        assert(package:check_csnippets({test = [[
            #include <yyjson.h>
            void test(void) {
                yyjson_doc *doc = yyjson_read("{\"hello\":\"world\"}", 17, 0);
                if (doc) {
                    yyjson_doc_free(doc);
                }
            }
        ]]}))
    end)
