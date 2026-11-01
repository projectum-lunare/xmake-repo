-- Projectum Lunare Xmake Repository - lua-iconv Package
-- Category: System, Hardware & Native Bindings
-- Lua binding to the POSIX 'iconv' library
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("lua-iconv")
    set_homepage("https://github.com/lunarmodules/lua-iconv")
    set_description("Lua binding to the POSIX 'iconv' library.")
    set_license("MIT")

    add_urls("https://github.com/lunarmodules/lua-iconv/archive/refs/tags/v$(version).tar.gz")
    add_urls("https://github.com/lunarmodules/lua-iconv.git")

    add_versions("7.1.0", "2539ed57e0e976c68244ae0a1733005037984f620f87c2c107322d24559d6e1e")
    add_versions("7.0.0", "1de42f2d0d0ee9ec45704b8ec0ce267ec67f75f7c9b0dedc24f742410604372b")

    add_deps("libiconv")

    on_load(function (package)
        import("@addon.forge.lua.runtime").setup(package, {
            runtime = {"lua", "luajit"},
        })
    end)

    on_install(function (package)
        local modname = package:config("shared") and "iconv" or "lua-iconv"
        io.writefile("xmake.lua", string.format([[
            add_requires("libiconv")

            target("%s")
                add_rules("forge.lua.module")
                add_packages("libiconv")
                add_files("luaiconv.c")
        ]], modname))
        import("@addon.forge.lua.module").install_project(package)
    end)

    on_test(function (package)
        if package:is_plat("linux", "macosx", "bsd") and not package:config("shared") then
            return
        end
        import("@addon.forge.lua.module").lua_test(package, [[
            local iconv = require("iconv")
            assert(iconv and iconv.VERSION)
            local cd = iconv.new("iso-8859-1", "utf-8")
            assert(cd and cd.iconv)
            local out, err = cd:iconv("teste")
            assert(out == "teste", err)
        ]])
    end)
