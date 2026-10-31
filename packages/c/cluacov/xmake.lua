-- Projectum Lunare Xmake Repository - cluacov Package
-- C extensions for LuaCov
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("cluacov")
    set_homepage("https://github.com/lunarmodules/cluacov")
    set_description("C extensions for LuaCov, improving coverage analysis performance.")
    set_license("MIT")

    add_urls("https://github.com/lunarmodules/cluacov/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/lunarmodules/cluacov.git")

    add_versions("1.0.0", "0d4683d195ec69b070ba6d37ccb07b4c428cba38a727b0e2c2f4ba77e90df4b6")
    add_versions("0.1.4", "6d96004bb17ef14c3569934d64651d7fd0d451c6e733f71590989a334a3a7ddb")

    add_deps("lua")
    add_deps("luacov")
    add_deps("forge master", {kind = "addon"})

    on_install(function (package)
        io.writefile("xmake.lua", [[
            target("cluacov.deepactivelines")
                add_rules("forge.lua.module")
                add_files("src/cluacov/deepactivelines.c")

            target("cluacov.hook")
                add_rules("forge.lua.module")
                add_files("src/cluacov/hook.c")

            target("cluacov.version")
                add_rules("forge.lua.module")
                add_files("src/cluacov/version.lua", {rootdir = "src"})
        ]])
        import("@addon.forge.lua.module").install_project(package)
    end)

    on_test(function (package)
        if package:is_plat("linux", "macosx", "bsd", "windows", "mingw") and not package:config("shared") then
            return
        end
        import("@addon.forge.lua.module").lua_test(package, [[
            local dal = require("cluacov.deepactivelines")
            assert(dal)
            local hook = require("cluacov.hook")
            assert(hook)
            local ver = require("cluacov.version")
            assert(ver)
        ]])
    end)
