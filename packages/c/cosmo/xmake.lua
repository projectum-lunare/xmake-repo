-- Projectum Lunare Xmake Repository - cosmo Package
-- Category: Parsing, Data Formats & Templates
-- Safe templates for Lua
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("cosmo")
    set_homepage("https://github.com/mascarenhas/cosmo")
    set_description("Safe templates for Lua.")
    set_license("MIT")

    add_urls("https://github.com/mascarenhas/cosmo/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/mascarenhas/cosmo.git")

    add_versions("v16.06.04", "86d17aea5080a90671d965cffeb9b104c19e0e1ea55c08687c0924c4512b52b1")
    add_versions("v10.04.06", "e55f43331f87c693e71bcaa9bd3e2e5002a8b0228908381a49c1f56d22746e0a")

    if is_plat("windows", "mingw", "linux", "macosx", "bsd", "haiku") then
        add_deps("lpeg", {configs = {shared = true}})
    else
        add_deps("lpeg")
    end

    on_load(function (package)
        import("@addon.recudo.lua.runtime").setup(package, {
            runtime = {"lua", "luajit"},
            default = "lua",
        })
    end)


    on_install(function (package)
        io.replace("src/cosmo/fill.lua", "for e, literal in coroutine.wrap(selector), args, true do", "for raw_e, literal in coroutine.wrap(selector), args, true do local e = raw_e", {plain = true})
        io.replace("src/cosmo/fill.lua", "for _, e in ipairs(selector) do", "for _, raw_e in ipairs(selector) do local e = raw_e", {plain = true})
        io.replace("src/cosmo/fill.lua", "for e, literal in coroutine.wrap(selector), nil, true do", "for raw_e, literal in coroutine.wrap(selector), nil, true do local e = raw_e", {plain = true})

        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            includes("@addon/recudo/recudo.lua")

            target("cosmo")
                add_rules("recudo.lua.module")
                add_files("src/cosmo.lua")
                add_files("src/cosmo/*.lua", {prefixdir = "cosmo"})
        ]])
        import("@addon.recudo.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.recudo.lua.module").lua_test(package, "local cosmo = require('cosmo'); assert(cosmo.fill('$a', {a = 'hello'}) == 'hello')")
    end)
