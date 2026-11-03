-- Projectum Lunare Xmake Repository - expadom Package
-- Category: Parsing, Data Formats & Templates
-- Expat based XML DOM level 2 handling for Lua
-- Supported Platforms: All platforms supporting Lua (POSIX, Windows, Vintage, Embedded)

package("expadom")
    set_homepage("https://github.com/lunarmodules/expadom")
    set_description("Expat based XML DOM level 2 handling for Lua.")
    set_license("MIT")

    add_urls("https://github.com/lunarmodules/expadom/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/lunarmodules/expadom.git")

    add_versions("0.1.0", "8165fc6310e832e9c90b4630a57f4271e517420e5b384ed13ae7d308ce094ad0")

    add_deps("lua")
    if is_plat("windows", "mingw", "linux", "macosx", "bsd", "haiku") then
        add_deps("luaexpat", {configs = {shared = true}})
    else
        add_deps("luaexpat")
    end
    add_deps("recudo master", {kind = "addon"})
    set_kind("library", {headeronly = true})

    on_install(function (package)
        io.replace("src/expadom/class.lua",
            "for prop_name, p in pairs(properties) do",
            "for raw_prop_name, p in pairs(properties) do\n\t\tlocal prop_name = raw_prop_name",
            {plain = true})

        io.writefile("xmake.lua", [[
            target("expadom")
                add_rules("recudo.lua.module")
                add_files("src/expadom/**.lua", {rootdir = "src"})
        ]])
        import("@addon.recudo.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.recudo.lua.module").lua_test(package, [[
            local expadom = require("expadom")
            assert(expadom and expadom.parseDocument)
            local doc = expadom.parseDocument("<root><child/></root>")
            assert(doc and doc.documentElement.nodeName == "root")
        ]])
    end)
