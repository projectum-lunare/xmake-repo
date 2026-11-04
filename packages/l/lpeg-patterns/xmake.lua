-- Projectum Lunare Xmake Repository - lpeg-patterns Package
-- Category: Parsing, Data Formats & Serialization
-- A collection of useful LPeg patterns (URI, HTTP, IPv4, IPv6, email, etc.)
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("lpeg-patterns")
    set_homepage("https://github.com/daurnimator/lpeg_patterns")
    set_description("A collection of useful LPeg patterns (URI, HTTP, IPv4, IPv6, email, etc.).")
    set_license("MIT")

    add_urls("https://github.com/daurnimator/lpeg_patterns/archive/refs/tags/v$(version).tar.gz")
    add_urls("https://github.com/daurnimator/lpeg_patterns.git")

    add_versions("0.5", "d1fabf897024822eb2544fd811fc80b85655972804511b9fd8cfea377fb16e0e")

    on_load(function (package)
        import("@addon.recudo.lua.runtime").setup(package, {
            runtime = {"lua", "luajit"},
            default = "lua",
        })
        package:add("deps", "lpeg", {configs = {shared = true}})
    end)

    on_install(function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            includes("@addon/recudo/recudo.lua")

            target("lpeg_patterns")
                add_rules("recudo.lua.module")
                add_packages("lua")
                add_files("lpeg_patterns/**.lua")
        ]])
        import("@addon.recudo.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.recudo.lua.module").lua_test(package, [[
            local ipv4 = require("lpeg_patterns.IPv4")
            assert(ipv4.IPv4address:match("127.0.0.1"))
        ]])
    end)
