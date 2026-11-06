-- Projectum Lunare Xmake Repository - parson Package
-- Category: Parsing, Data Formats & Templates
-- Lightweight JSON library written in ANSI C89
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("parson")
    set_homepage("https://github.com/kgabis/parson")
    set_description("Lightweight JSON library written in C89.")
    set_license("MIT")

    local commits = {
        ["1.5.4"] = "ec53fb6528b45811df9db0db22cab96a94a96a11",
        ["1.5.3"] = "ba29f4eda94e772215c71d64c1ecddbbab4bf210"
    }

    add_urls("https://github.com/kgabis/parson/archive/$(version).tar.gz", {version = function (version) return commits[tostring(version)] end})
    add_urls("https://github.com/kgabis/parson.git")

    add_versions("1.5.4", "9ca55b19539a019dd86234543a965be4533be600a8d2539d0046322888df4a41")
    add_versions("1.5.3", "d5558cd419c8d46bdc958064cb97f963d1ea793866414c025906ec15033512ed")

    on_install(function (package)
        io.writefile("xmake.lua", [[
            set_languages("c89")
            add_rules("mode.release", "mode.debug")

            target("parson")
                set_kind("$(kind)")
                add_headerfiles("parson.h")
                add_files("parson.c")
        ]])
        import("package.tools.xmake").install(package)
    end)

    on_test(function (package)
        assert(package:has_cincludes("parson.h"))
        assert(package:check_csnippets({test = [[
            #include <parson.h>
            void test(void) {
                JSON_Value *val = json_parse_string("{\"hello\":\"world\"}");
                if (val) {
                    json_value_free(val);
                }
            }
        ]]}))
    end)
