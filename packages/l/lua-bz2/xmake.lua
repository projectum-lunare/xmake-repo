-- Projectum Lunare Xmake Repository - lua-bz2 Package
-- Category: System, Hardware & Native Bindings
-- A Lua binding to Julian Seward's libbzip2
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("lua-bz2")
    set_homepage("https://github.com/lunarmodules/lua-bz2")
    set_description("A Lua binding to Julian Seward's libbzip2.")
    set_license("ISC")

    add_urls("https://github.com/lunarmodules/lua-bz2/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/lunarmodules/lua-bz2.git")

    add_versions("0.2.3", "8c96c47a2e5904c1d24f18b0fd357f12ca8c26e22b960f4a36133f6e5c6a8690")
    add_versions("0.2.2", "da0c5c4a3b9e22fcb62517cd13078328042fd46dd44426f7ac03bfbb30371468")
    add_versions("0.2.1.1", "63299dd019fdbb73e809dba6cadb0e2bfc91f6fb549b92ee59f762f7459b47f4")
    add_versions("0.2.1", "095fc7e8c169d1d0ae2017b1a32a179754580b1464a72c50669487583fb20184")
    add_versions("0.2.0", "b348eacd1b67bd0552d725e3b6bab43a732b742f514656a73a801d500dc100a3")
    add_versions("0.1.0", "08bc6ce5faa96d60890b485bb9f5370cde56906d64a482a4cc1efa7ee5d88716")

    add_deps("bzip2")

    on_load(function (package)
        import("@addon.recudo.lua.runtime").setup(package, {
            runtime = {"lua", "luajit"},
        })
    end)

    on_install(function (package)
        local modname = package:config("shared") and "bz2" or "lua-bz2"
        io.writefile("xmake.lua", string.format([[
            add_requires("bzip2")

            target("%s")
                add_rules("recudo.lua.module")
                add_packages("bzip2")
                add_defines("COMPAT53_PREFIX=compat53")
                add_files(
                    "lbz.c",
                    "lbz2_common.c",
                    "lbz2_file_reader.c",
                    "lbz2_file_writer.c",
                    "lbz2_stream.c",
                    "compat-5.3.c"
                )

            if os.isfile("bz2/ltn12.lua") then
                target("bz2.ltn12")
                    add_rules("recudo.lua.module")
                    add_packages("lua")
                    add_files("bz2/ltn12.lua")
            end
        ]], modname))
        import("@addon.recudo.lua.module").install_project(package)
    end)

    on_test(function (package)
        if package:is_plat("linux", "macosx", "bsd") and not package:config("shared") then
            return
        end
        import("@addon.recudo.lua.module").lua_test(package, [[
            local bz2 = require("bz2")
            assert(bz2)
            local comp = assert(bz2.initCompress())
            local data = "test string"
            local compressed = assert(comp:update(data)) .. assert(comp:update(nil))
            comp:close()
            local decomp = assert(bz2.initDecompress())
            local original = assert(decomp:update(compressed))
            decomp:close()
            assert(original == data)
        ]])
    end)
