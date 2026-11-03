-- Projectum Lunare Xmake Repository - lua-compat-5.3 Package
-- Category: Runtimes & Core Language
-- Compatibility module providing Lua-5.3-style APIs for Lua 5.2 and 5.1
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("lua-compat-5.3")
    set_homepage("https://github.com/lunarmodules/lua-compat-5.3")
    set_description("Compatibility module providing Lua-5.3-style APIs for Lua 5.2 and 5.1.")
    set_license("MIT")

    add_urls("https://github.com/lunarmodules/lua-compat-5.3/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/lunarmodules/lua-compat-5.3.git")

    add_versions("v0.15.1", "16c4bd7b72a156e3b575ce2b5ebe2ec00611a14c485dd15dc3814647a589c7f8")
    add_versions("v0.15.0", "47caa8cabb85a4ddaefb9445528504b0197a15b39fec3ac9b29818d647198b23")

    on_load(function (package)
        import("@addon.recudo.lua.runtime").setup(package, {
            runtime = {"lua", "luajit"},
            version = ">=5.1 <=5.3",
        })
    end)

    add_includedirs("include", "include/compat-5.3")

    on_install(function (package)
        io.writefile("xmake.lua", [[
            target("compat53")
                add_rules("recudo.lua.module")
                add_files("compat53/*.lua")
                add_headerfiles("c-api/(compat-5.3.h)")
                add_headerfiles("c-api/compat-5.3.h", {prefixdir = "compat-5.3"})

            target("compat53.utf8")
                add_rules("recudo.lua.module")
                add_includedirs(".", "c-api")
                add_files("lutf8lib.c", "c-api/compat-5.3.c")

            target("compat53.table")
                add_rules("recudo.lua.module")
                add_includedirs(".", "c-api")
                add_files("ltablib.c", "c-api/compat-5.3.c")

            target("compat53.string")
                add_rules("recudo.lua.module")
                add_includedirs(".", "c-api")
                add_files("lstrlib.c", "c-api/compat-5.3.c")

            target("compat53.io")
                add_rules("recudo.lua.module")
                add_includedirs(".", "c-api")
                add_files("liolib.c", "c-api/compat-5.3.c")
        ]])
        import("@addon.recudo.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.recudo.lua.module").lua_test(package, "assert(require('compat53'))")
    end)
