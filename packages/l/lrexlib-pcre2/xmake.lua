-- Projectum Lunare Xmake Repository - lrexlib-pcre2 Package
-- Category: Languages, Encodings & String Processing
-- Regular expression library binding PCRE2 to Lua
-- Supported Platforms: Linux, macOS, Windows, BSD, Haiku, WASM

package("lrexlib-pcre2")
    set_homepage("https://github.com/rrthomas/lrexlib")
    set_description("Regular expression library binding PCRE2 to Lua.")
    set_license("MIT")

    add_urls("https://github.com/rrthomas/lrexlib/archive/refs/tags/rel-$(version).tar.gz", {version = function (version)
        return version:gsub("%.", "-")
    end})
    add_urls("https://github.com/rrthomas/lrexlib.git")

    add_versions("2.9.4", "541d4f4eaaf8b8030cc105a0e47c0e66c440aab001dd8d9717770800b736a678")
    add_versions("2.9.3", "acbf19adf1aac7ad3ac7d824cdabfb13124e2c77da8415f50e6732ce94ac2bca")
    add_versions("2.9.2", "e32577792b199b2daa0106df59417c29f7e22f232c594be75564e3cc201ec12e")

    add_deps("pcre2")

    on_load(function (package)
        import("@addon.recudo.lua.runtime").setup(package, {
            runtime = {"lua", "luajit"},
        })
    end)

    on_install(function (package)
        io.writefile("xmake.lua", string.format([[
            add_requires("pcre2")

            target("rex_pcre2")
                add_rules("recudo.lua.module")
                add_packages("pcre2")
                add_includedirs("src")
                add_defines("PCRE2_CODE_UNIT_WIDTH=8", "VERSION=\"%s\"")
                add_files(
                    "src/common.c",
                    "src/pcre2/lpcre2.c",
                    "src/pcre2/lpcre2_f.c"
                )
        ]], package:version_str()))
        import("@addon.recudo.lua.module").install_project(package)
    end)

    on_test(function (package)
        if package:is_plat("linux", "macosx", "bsd") and not package:config("shared") then
            return
        end
        import("@addon.recudo.lua.module").lua_test(package, [[
            local rex = require("rex_pcre2")
            assert(rex and type(rex.match) == "function")
            assert(rex.match("hello world", "world") == "world")
        ]])
    end)
