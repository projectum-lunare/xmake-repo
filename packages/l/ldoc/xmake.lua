-- Projectum Lunare Xmake Repository - LDoc Package
-- Category: Testing, Code Quality & Documentation
-- A Lua Documentation Tool
-- Supported Platforms: All platforms supporting Lua (POSIX, Windows, Vintage, Embedded)

package("ldoc")
    set_homepage("https://github.com/lunarmodules/ldoc")
    set_description("A Lua Documentation Tool.")
    set_license("MIT")

    add_urls("https://github.com/lunarmodules/ldoc/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/lunarmodules/ldoc.git")

    add_versions("v1.5.0", "4469cd74c8c7f51d3b9ce802d2239ba2b09d3d3a11273c3a5abdf273a0a53531")
    add_versions("1.4.6", "7eb5097ad786ac44c963e586d6953de3970edf772c251ac6f91dc170210d429d")

    add_deps("lua")
    add_deps("penlight")
    add_deps("markdown")
    add_deps("recudo master", {kind = "addon"})
    set_kind("library", {headeronly = true})
    add_bindirs("bin")

    on_install(function (package)
        io.replace("ldoc/html.lua", "tag = stringx.title(tag)", "local tag = stringx.title(tag)", {plain = true})
        io.replace("ldoc/html.lua", "name = ref.label", "local name = ref.label", {plain = true})
        io.replace("ldoc/markdown.lua", "k = k:gsub(\"%%\", \"%%%%\")", "local k = k:gsub(\"%%\", \"%%%%\")", {plain = true})

        io.writefile("xmake.lua", [[
            target("ldoc")
                add_rules("recudo.lua.module")
                add_files("ldoc/**.lua")

            target("ldoc.bin")
                add_rules("recudo.lua.bin")
                add_files("ldoc.lua")
        ]])
        import("@addon.recudo.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.recudo.lua.module").lua_test(package, [[
            local tools = require("ldoc.tools")
            assert(tools)
            local doc = require("ldoc.doc")
            assert(doc)
        ]])
    end)
