-- Projectum Lunare Xmake Repository - Luacheck Package
-- Category: Testing, Code Quality & Documentation
-- A static analyzer and a linter for Lua
-- Supported Platforms: All platforms supporting Lua (POSIX, Windows, Vintage, Embedded)

package("luacheck")
    set_homepage("https://github.com/lunarmodules/luacheck")
    set_description("A static analyzer and a linter for Lua.")
    set_license("MIT")

    add_urls("https://github.com/lunarmodules/luacheck/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/lunarmodules/luacheck.git")

    add_versions("v1.2.0", "8efe62a7da4fdb32c0c22ec1f7c9306cbc397d7d40493c29988221a059636e25")
    add_versions("v1.1.2", "a3ae089f3939b9fba4dd91c8c6f206e088cc4b21b49f1b6c7a5cc7345a09dc19")
    add_versions("v1.1.1", "6ef4276498c4bb4ec527c3f942e35ff5c71fdd8c88ed0619a83a1c967d135c81")

    add_deps("lua")
    add_deps("argparse")
    if is_plat("windows", "mingw", "linux", "macosx", "bsd", "haiku") then
        add_deps("luafilesystem", {configs = {shared = true}})
    else
        add_deps("luafilesystem")
    end
    add_deps("forge master", {kind = "addon"})
    set_kind("library", {headeronly = true})
    add_bindirs("bin")

    on_install(function (package)
        io.replace("src/luacheck/standards.lua",
            "for field_name, field_def in pairs(fields) do",
            "for raw_field_name, raw_field_def in pairs(fields) do\n      local field_name, field_def = raw_field_name, raw_field_def",
            {plain = true})

        io.writefile("xmake.lua", [[
            target("luacheck")
                add_rules("forge.lua.module")
                add_files("src/luacheck/**.lua", {rootdir = "src"})

            target("luacheck.bin")
                add_rules("forge.lua.bin")
                add_files("bin/luacheck.lua")
        ]])
        import("@addon.forge.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.forge.lua.module").lua_test(package, [[
            local luacheck = require("luacheck")
            assert(luacheck and luacheck.check_strings)
            local report = luacheck.check_strings({"local a = 1"})
            assert(report.warnings == 1)
        ]])
    end)
