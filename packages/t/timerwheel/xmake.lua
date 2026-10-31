-- Projectum Lunare Xmake Repository - timerwheel Package
-- Timer wheel implementation in pure Lua
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("timerwheel")
    set_homepage("https://github.com/Tieske/timerwheel.lua")
    set_description("A timer wheel implementation in pure Lua.")
    set_license("MIT")

    add_urls("https://github.com/Tieske/timerwheel.lua/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/Tieske/timerwheel.lua.git")

    add_versions("1.0.2", "a3d0159bcf996f3c73ac20d6168d2aaedcd6877df8f7ae6a1994010ad8492784")
    add_versions("1.0.1", "fcbef22ddb623337e9ac76eb3edeb60b22210f2368679aac13884582156e1f08")
    add_versions("1.0.0", "2e126a3f5100fb6f05ef7cded4c2e5775871eca0ee5af907f8cfbf6f406765f3")

    add_deps("lua")
    add_deps("binaryheap")
    add_deps("coxpcall")
    add_deps("forge master", {kind = "addon"})

    on_install(function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            includes("@addon/forge/forge.lua")

            target("timerwheel")
                add_rules("forge.lua.module")
                add_packages("lua")
                add_files("src/timerwheel/init.lua")
        ]])
        import("@addon.forge.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.forge.lua.module").lua_test(package, [[
            local timerwheel = require("timerwheel")
            local wheel = timerwheel.new({ precision = 0.1, now = os.time })
            assert(wheel)
        ]])
    end)
