-- Projectum Lunare Xmake Repository - lanes Package
-- Category: Concurrency, Asynchronous & Coroutines
-- Multithreading support for Lua with OS threads and Linda message passing
-- Supported Platforms: Linux, macOS, BSD, Windows, Haiku

package("lanes")
    set_homepage("https://github.com/LuaLanes/lanes")
    set_description("Multithreading support for Lua using OS threads and message passing.")
    set_license("MIT")

    add_urls("https://github.com/LuaLanes/lanes/archive/refs/tags/v$(version).tar.gz")
    add_urls("https://github.com/LuaLanes/lanes.git")

    add_versions("4.0.0", "e680253ce5d64da1fd5c8d44d31dd1eb4fe7e24cfa5ddded10fa34cbee92d179")

    add_patches("4.0.0", "patches/4.0.0/unistd.patch", "0a5b23edbf5d7af59c7cdf0eaf3887acbae0f9047889ab57e6f920e830189d5d")

    if is_plat("linux", "macosx", "bsd", "haiku") then
        add_syslinks("pthread")
    end

    on_load(function (package)
        import("@addon.recudo.lua.runtime").setup(package, {
            runtime = {"lua", "luajit"},
        })
    end)

    on_install(function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            set_languages("c++20")

            target("lanes_core")
                add_rules("recudo.lua.module")
                add_includedirs("src")
                add_files("src/*.cpp")
                if is_plat("linux", "macosx", "bsd", "haiku") then
                    add_syslinks("pthread")
                end

            target("lanes")
                add_rules("recudo.lua.module")
                add_files("src/lanes.lua")
        ]])
        import("@addon.recudo.lua.module").install_project(package)
    end)

    on_test(function (package)
        if package:config("shared") then
            import("@addon.recudo.lua.module").lua_test(package, [[
                local lanes = require("lanes").configure()
                local linda = lanes.linda()
                linda:send("channel", 42)
                local key, val = linda:receive("channel")
                assert(key == "channel")
                assert(val == 42)
            ]])
        end
    end)
