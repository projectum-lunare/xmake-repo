-- Projectum Lunare Xmake Repository - wsapi Package
-- Category: Networking, Web & Services
-- Lua Web Server API
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("wsapi")
    set_homepage("https://github.com/keplerproject/wsapi")
    set_description("WSAPI is an API that abstracts the web server from Lua web applications.")
    set_license("MIT")

    add_urls("https://github.com/keplerproject/wsapi/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/keplerproject/wsapi.git")

    add_versions("v1.7", "48dc7aba0fd2e96a3e5ef51045b5d923964f6ae299de761aa0467031ad44e987")
    add_versions("v1.6.1", "49c73a35c69e8a708c6247223969c4005dd9bebb8b036343b10d1c9020e73a04")

    add_deps("coxpcall")
    if is_plat("windows", "mingw", "linux", "macosx", "bsd", "haiku") then
        add_deps("luafilesystem", {configs = {shared = true}})
        add_deps("rings", {configs = {shared = true}})
    else
        add_deps("luafilesystem")
        add_deps("rings")
    end

    on_load(function (package)
        import("@addon.recudo.lua.runtime").setup(package, {
            runtime = {"lua", "luajit"},
            default = "lua",
        })
    end)


    on_install(function (package)
        io.replace("src/wsapi/request.lua", "type = string.lower(type)", "local type = string.lower(type)", {plain = true})
        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            includes("@addon/recudo/recudo.lua")

            target("wsapi")
                add_rules("recudo.lua.module")
                add_files("src/wsapi.lua")
                add_files("src/wsapi/*.lua", {prefixdir = "wsapi"})

            target("wsapi.cgi")
                add_rules("recudo.lua.bin")
                add_files("src/launcher/wsapi.cgi")
        ]])
        import("@addon.recudo.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.recudo.lua.module").lua_test(package, "local req = require('wsapi.request'); local res = require('wsapi.response'); assert(req.new and res.new)")
    end)
