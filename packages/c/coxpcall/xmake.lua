-- Projectum Lunare Xmake Repository - coxpcall Package
-- Category: Data Structures, Concurrency & Utilities
-- Coroutine-safe xpcall and pcall implementations for Lua
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("coxpcall")
    set_homepage("https://github.com/keplerproject/coxpcall")
    set_description("Coroutine-safe xpcall and pcall implementations for Lua.")
    set_license("MIT")

    add_urls("https://github.com/keplerproject/coxpcall/archive/refs/tags/v$(version).tar.gz", {version = function (version)
        return version:gsub("%.", "_")
    end})
    add_urls("https://github.com/keplerproject/coxpcall.git")

    add_versions("1.17.0", "6044f70fcc01f50cae3a191cba13c252dcf9e6f169502e3d9c4a151934c46be0")
    add_versions("1.16.0", "b732add4d8c2c56d82a176cf38c11ff1b799c02f220cb29dcd332b91adc34b16")

    add_deps("lua")
    add_deps("forge master", {kind = "addon"})

    on_install(function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            includes("@addon/forge/forge.lua")

            target("coxpcall")
                add_rules("forge.lua.module")
                add_packages("lua")
                add_files("src/coxpcall.lua")
        ]])
        import("@addon.forge.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.forge.lua.module").lua_test(package, [[
            local coxpcall = require("coxpcall")
            assert(type(coxpcall.pcall) == "function")
            assert(type(coxpcall.xpcall) == "function")
        ]])
    end)
