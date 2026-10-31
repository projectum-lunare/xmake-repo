-- Projectum Lunare Xmake Repository - CGILua Package
-- Category: Networking, Web & Services
-- Tool for creating dynamic Web pages and manipulating data from Web forms
-- Supported Platforms: All platforms supporting Lua (POSIX, Windows, Vintage, Embedded)

package("cgilua")
    set_homepage("https://github.com/lunarmodules/cgilua")
    set_description("Tool for creating dynamic Web pages and manipulating data from Web forms.")
    set_license("MIT")

    add_urls("https://github.com/lunarmodules/cgilua/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/lunarmodules/cgilua.git")

    add_versions("6.0.2", "43eb0fedb8eb436fc44e41840a2715f41e1161e97568693dfd53ada16e193d12")
    add_versions("v5.2.1", "6b2d81f9363595d0f6c8158b9c2e9f438d2aced0e31bde6cc5b7f06270bd4711")
    add_versions("v5.1.4", "56f295119763a83ff6d2cef21d612ccc81b5ec6f1b2f51a2f9619501bb421fbb")

    add_deps("lua")
    if is_plat("windows", "mingw", "linux", "macosx", "bsd", "haiku") then
        add_deps("luafilesystem", {configs = {shared = true}})
    else
        add_deps("luafilesystem")
    end
    add_deps("forge master", {kind = "addon"})
    set_kind("library", {headeronly = true})
    add_bindirs("bin")

    on_install(function (package)
        io.replace("src/cgilua/post.lua", "name = strlower(name)", "local name = strlower(name)", {plain = true})
        io.writefile("src/cgilua/init.lua", "return require('cgilua.main')\n")

        io.writefile("xmake.lua", [[
            target("cgilua")
                add_rules("forge.lua.module")
                add_files("src/cgilua/**.lua", {rootdir = "src"})

            target("cgilua.launchers")
                add_rules("forge.lua.bin")
                add_files("src/launchers/cgilua.cgi")
                add_files("src/launchers/cgilua.fcgi")
        ]])
        import("@addon.forge.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.forge.lua.module").lua_test(package, [[
            local cgilua = require("cgilua")
            assert(cgilua and cgilua._VERSION)
            local urlcode = require("cgilua.urlcode")
            assert(urlcode and urlcode.escape)
        ]])
    end)
