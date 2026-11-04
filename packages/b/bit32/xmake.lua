-- Projectum Lunare Xmake Repository - bit32 Package
-- Category: Languages, Encodings & String Processing
-- Standard library for bitwise operations (backported Lua 5.2 bit32 library)
-- Supported Platforms: Linux, macOS, Windows, BSD, Haiku, WASM

package("bit32")
    set_homepage("https://www.lua.org/manual/5.2/manual.html#6.7")
    set_description("Standard library for bitwise operations (backported Lua 5.2 bit32 library).")
    set_license("MIT")

    add_urls("https://github.com/keplerproject/lua-compat-5.2/archive/refs/tags/bitlib-$(version).tar.gz")
    add_urls("https://github.com/keplerproject/lua-compat-5.2.git")

    add_versions("5.3.0", "dc1197b9e996b7bd2c6a679b86ed75106d5722424b3e731b8084f56626ec5552")
    add_versions("5.2.3", "c95faafbf528f842fcd13b3d370388ad2632d9de01f541915f6ecb207f842eac")
    add_versions("5.2.2", "ce53b8e57833e19f61320f0c15b2300444100e34490af2547121f84af13a2ce9")

    on_load(function (package)
        import("@addon.recudo.lua.runtime").setup(package, {
            runtime = {"lua", "luajit"},
            version = "5.1",
        })
    end)

    on_install(function (package)
        io.replace("lbitlib.c", "LUA_VERSION_NUM == 503", "LUA_VERSION_NUM >= 503", {plain = true})
        io.writefile("xmake.lua", [[
            target("bit32")
                add_rules("recudo.lua.module")
                add_includedirs("c-api")
                add_files("lbitlib.c")
        ]])
        import("@addon.recudo.lua.module").install_project(package)
    end)

    on_test(function (package)
        if package:is_plat("linux", "macosx", "bsd") and not package:config("shared") then
            return
        end
        import("@addon.recudo.lua.module").lua_test(package, [[
            local bit = require("bit32")
            assert(bit and type(bit.band) == "function")
            assert(bit.band(7, 3) == 3)
            assert(bit.bor(4, 2) == 6)
            assert(bit.bxor(7, 3) == 4)
            assert(bit.bnot(0) == 4294967295 or bit.bnot(0) == -1)
        ]])
    end)
