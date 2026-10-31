-- Projectum Lunare Xmake Repository - libyaml Package
-- A C library for parsing and emitting YAML
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("libyaml")
    set_homepage("https://github.com/yaml/libyaml")
    set_description("A C library for parsing and emitting YAML.")
    set_license("MIT")

    add_urls("https://github.com/yaml/libyaml/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/yaml/libyaml.git")

    add_versions("0.2.5", "fa240dbf262be053f3898006d502d514936c818e422afdcf33921c63bed9bf2e")
    add_versions("0.2.4", "02265e0229675aea3a413164b43004045617174bdb2c92bf6782f618f8796b55")

    add_includedirs("include")
    if is_plat("windows") and not is_kind("shared") then
        add_defines("YAML_DECLARE_STATIC")
    end

    on_install(function (package)
        local version = package:version()
        local major = version:major() or 0
        local minor = version:minor() or 2
        local patch = version:patch() or 5
        io.writefile("include/config.h", format([[
#define YAML_VERSION_MAJOR %s
#define YAML_VERSION_MINOR %s
#define YAML_VERSION_PATCH %s
#define YAML_VERSION_STRING "%s"
]], major, minor, patch, version))

        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")

            target("yaml")
                set_kind("$(kind)")
                add_defines("HAVE_CONFIG_H")
                add_includedirs("include", "src")
                add_headerfiles("include/yaml.h")
                add_files("src/*.c")
                if is_plat("windows") and not is_kind("shared") then
                    add_defines("YAML_DECLARE_STATIC")
                end
        ]])
        import("package.tools.xmake").install(package)
    end)

    on_test(function (package)
        assert(package:has_cincludes("yaml.h"))
        assert(package:check_csnippets({test = [[
            #include <yaml.h>
            void test(void) {
                yaml_parser_t parser;
                yaml_parser_initialize(&parser);
                yaml_parser_delete(&parser);
            }
        ]]}))
    end)
