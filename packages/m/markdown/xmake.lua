-- Projectum Lunare Xmake Repository - Markdown Package
-- Category: Parsing, Data Formats & Templates
-- Pure Lua implementation of the Markdown text-to-html markup system
-- Supported Platforms: All platforms supporting Lua (POSIX, Windows, Vintage, Embedded)

package("markdown")
    set_homepage("https://github.com/lunarmodules/markdown")
    set_description("Pure Lua implementation of the Markdown text-to-html markup system.")
    set_license("MIT")

    add_urls("https://github.com/lunarmodules/markdown/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/lunarmodules/markdown.git")

    add_versions("0.33", "c94fa6669f3b00a1047c50de4ee26e422a3bacb15ca4ed576b2f4d67d16f1f09")

    add_deps("lua")
    add_deps("recudo master", {kind = "addon"})
    set_kind("library", {headeronly = true})

    on_install(function (package)
        io.replace("markdown.lua",
            "for k,v in pairs(escape_table) do\n      k = k:gsub(\"%%\", \"%%%%\")",
            "for k,v in pairs(escape_table) do\n      local k = k:gsub(\"%%\", \"%%%%\")",
            {plain = true})

        io.writefile("xmake.lua", [[
            target("markdown")
                add_rules("recudo.lua.module")
                add_files("markdown.lua")
        ]])
        import("@addon.recudo.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.recudo.lua.module").lua_test(package, [[
            local markdown = require("markdown")
            local html = markdown("# Hello World")
            assert(html:find("<h1>Hello World</h1>"))
        ]])
    end)
