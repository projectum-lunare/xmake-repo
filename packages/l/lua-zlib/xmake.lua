-- Projectum Lunare Xmake Repository - lua-zlib Package
-- Category: System, Hardware & Native Extensions
-- Simple streaming zlib (deflate/inflate/gzip) bindings for Lua
-- Supported Platforms: Linux, macOS, BSD, Windows, Haiku

package("lua-zlib")
    set_homepage("https://github.com/brimworks/lua-zlib")
    set_description("Simple streaming zlib (deflate/inflate/gzip) bindings for Lua.")
    set_license("MIT")

    add_urls("https://github.com/brimworks/lua-zlib/archive/refs/tags/v$(version).tar.gz")
    add_urls("https://github.com/brimworks/lua-zlib.git")

    add_versions("1.4", "c2a59e96d2df6e192cf0bf6f19b312977ce24020c4072426c0cf8b6594767308")
    add_versions("1.3", "d026eda33b7c3456696bcecdc0b26d7bd779de4f5a4d4215ebe3897095c6c9c8")
    add_versions("1.2", "26b813ad39c94fc930b168c3418e2e746af3b2e80b92f94f306f6f954cc31e7d")

    on_load(function (package)
        import("@addon.recudo.lua.runtime").setup(package, {
            runtime = {"lua", "luajit"},
        })
        package:add("deps", "zlib")
    end)

    on_install(function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("zlib")
            target("zlib")
                add_rules("recudo.lua.module")
                add_packages("zlib")
                add_files("lua_zlib.c")
        ]])
        import("@addon.recudo.lua.module").install_project(package)
    end)

    on_test(function (package)
        if package:config("shared") then
            import("@addon.recudo.lua.module").lua_test(package, [[
                local zlib = require("zlib")
                assert(type(zlib.version) == "function" or type(zlib._VERSION) == "string")
                local deflater = zlib.deflate()
                local inflated, eof, bytes_in, bytes_out = zlib.inflate()(deflater("hello world", "finish"))
                assert(inflated == "hello world")
            ]])
        end
    end)
