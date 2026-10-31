-- Projectum Lunare Xmake Repository - Argparse Package
-- Category: CLI, Terminal & Text UI
-- A feature-rich command line parser for Lua
-- Supported Platforms: All platforms supporting Lua (POSIX, Windows, Vintage, Embedded)

package("argparse")
    set_homepage("https://github.com/luarocks/argparse")
    set_description("A feature-rich command line parser for Lua.")
    set_license("MIT")

    add_urls("https://github.com/luarocks/argparse/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/luarocks/argparse.git")

    add_versions("0.7.2", "d2ae8066939420957bb6d580c6a6b8176c4f05419eca318e48d90a670fe2f59e")
    add_versions("0.7.1", "d344e49404c3e7b3e7fa4fe6741c106f25909d9b24923cb08dcceda1f9754809")
    add_versions("0.7.0", "d85b31ca60d88c54ad743c3b5c4cdb0ae47ba57341c203a899b18c0277afec77")

    add_deps("lua")
    add_deps("forge master", {kind = "addon"})
    set_kind("library", {headeronly = true})

    on_install(function (package)
        io.writefile("xmake.lua", [[
            target("argparse")
                add_rules("forge.lua.module")
                add_files("src/argparse.lua")
        ]])
        import("@addon.forge.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.forge.lua.module").lua_test(package, [[
            local argparse = require("argparse")
            local parser = argparse("script", "An example program.")
            parser:argument("input")
            local args = parser:parse({"foo"})
            assert(args.input == "foo")
        ]])
    end)
