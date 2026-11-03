-- Projectum Lunare Xmake Repository - LuaCov Package
-- Category: Testing, Code Quality & Documentation
-- Simple coverage analysis tool for Lua scripts
-- Supported Platforms: All platforms supporting Lua (POSIX, Windows, Vintage, Embedded)

package("luacov")
    set_homepage("https://lunarmodules.github.io/luacov/")
    set_description("Coverage analysis tool for Lua scripts.")
    set_license("MIT")

    add_urls("https://github.com/lunarmodules/luacov/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/lunarmodules/luacov.git")

    add_versions("v0.17.0", "791a4a93a21b7288b1555cda8b7ad1ee0540ea606bd5dcc1028e76eeaec0e3d3")
    add_versions("v0.16.0", "0396d48fd12dd7dacf8bd3778d15ef17218e701f4a3c2f36e4e2a64b60db1736")
    add_versions("v0.15.0", "19ebe0fdd5dd05ab63d5192371dcf272f2c7ccea5366e98fee440a2f30e021d8")

    add_deps("lua")
    add_deps("recudo master", {kind = "addon"})
    set_kind("library", {headeronly = true})
    add_bindirs("bin")

    on_install(function (package)
        io.writefile("xmake.lua", [[
            target("luacov")
                add_rules("recudo.lua.module")
                add_files("src/**.lua")

            target("luacov.bin")
                add_rules("recudo.lua.bin")
                add_files("src/bin/luacov")
        ]])
        import("@addon.recudo.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.recudo.lua.module").lua_test(package, "assert(require('luacov'))")
        if not package:is_cross() then
            os.vrunv("luacov", {"--help"})
        end
    end)
