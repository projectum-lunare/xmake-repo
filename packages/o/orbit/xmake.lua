-- Projectum Lunare Xmake Repository - orbit Package
-- Category: Networking, Web & Services
-- MVC Web Development for the Kepler platform
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("orbit")
    set_homepage("http://keplerproject.github.io/orbit/")
    set_description("MVC Web Development for the Kepler platform.")
    set_license("MIT")

    add_urls("https://github.com/keplerproject/orbit/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/keplerproject/orbit.git")

    add_versions("v2.2.4", "eedfe095c8bd849cb231b4c543c7225051c3eb4ff37ba8af2d4aedd8123aa81f")
    add_versions("v2.2.3", "0fad7afb32cbdb6d96c07816edae15d1968cd0edbc66584a59c144d8ee41f1a1")

    add_deps("lua")
    add_deps("wsapi")
    add_deps("cosmo")
    if is_plat("windows", "mingw", "linux", "macosx", "bsd", "haiku") then
        add_deps("luafilesystem", {configs = {shared = true}})
        add_deps("lpeg", {configs = {shared = true}})
    else
        add_deps("luafilesystem")
        add_deps("lpeg")
    end
    add_deps("recudo master", {kind = "addon"})

    on_install(function (package)
        io.replace("src/orbit/model.lua", 'module("orbit.model", package.seeall)', 'local _M = {}; local _ENV = setmetatable(_M, {__index = _G}); package.loaded["orbit.model"] = _M', {plain = true})
        io.writefile("src/orbit/model.lua", io.readfile("src/orbit/model.lua") .. "\nreturn _M\n")
        io.replace("src/orbit/cache.lua", 'module("orbit.cache", package.seeall)', 'local _M = {}; local _ENV = setmetatable(_M, {__index = _G}); package.loaded["orbit.cache"] = _M', {plain = true})
        io.replace("src/orbit/pages.lua", 'module("orbit.pages", orbit.new)', 'local _M = orbit.new("orbit.pages"); local _ENV = setmetatable(_M, {__index = _G}); package.loaded["orbit.pages"] = _M', {plain = true})

        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            includes("@addon/recudo/recudo.lua")

            target("orbit")
                add_rules("recudo.lua.module")
                add_files("src/orbit.lua")
                add_files("src/orbit/*.lua", {prefixdir = "orbit"})

            target("orbit.launchers")
                add_rules("recudo.lua.bin")
                add_files("src/launchers/orbit")
                add_files("src/launchers/op.cgi")
                add_files("src/launchers/op.fcgi")
        ]])
        import("@addon.recudo.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.recudo.lua.module").lua_test(package, "local orbit = require('orbit'); local model = require('orbit.model'); local pages = require('orbit.pages'); assert(orbit.new and model.new and pages.load)")
    end)
