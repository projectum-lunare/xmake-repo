-- Projectum Lunare Xmake Repository - lyaml Package
-- Category: Parsing, Data Formats & Templates
-- LibYAML binding for Lua
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("lyaml")
    set_homepage("https://github.com/gvvaughan/lyaml")
    set_description("LibYAML binding for Lua.")
    set_license("MIT")

    add_urls("https://github.com/gvvaughan/lyaml/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/gvvaughan/lyaml.git")

    add_versions("v6.2.9", "515e81d21903c1e428b017f2fe9dffa4e29ae9881b0d49ddbe6ba625e3164fe3")
    add_versions("v6.2.8", "c6169f516ff2a8da96d55aa3a087e718edf7bceb2f1cae2def4e65cd2b41ac2d")

    add_deps("lua")
    if is_plat("windows", "mingw", "linux", "macosx", "bsd", "haiku") then
        add_deps("libyaml", {configs = {shared = true}})
    else
        add_deps("libyaml")
    end
    add_deps("forge master", {kind = "addon"})

    on_install(function (package)
        io.writefile("xmake.lua", format([[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            add_requires("libyaml")
            includes("@addon/forge/forge.lua")

            target("yaml")
                add_rules("forge.lua.module")
                add_packages("libyaml")
                add_defines('PACKAGE="lyaml"', 'VERSION="%s"')
                add_files("ext/yaml/yaml.c", "ext/yaml/emitter.c", "ext/yaml/parser.c", "ext/yaml/scanner.c")

            target("lyaml")
                add_rules("forge.lua.module")
                add_files("lib/lyaml/init.lua")
                add_files("lib/lyaml/explicit.lua", {prefixdir = "lyaml"})
                add_files("lib/lyaml/functional.lua", {prefixdir = "lyaml"})
                add_files("lib/lyaml/implicit.lua", {prefixdir = "lyaml"})
        ]], package:version()))
        import("@addon.forge.lua.module").install_project(package)
    end)

    on_test(function (package)
        if package:is_plat("linux", "macosx", "bsd", "windows", "mingw") and not package:config("shared") then
            return
        end
        import("@addon.forge.lua.module").lua_test(package, [[
            local lyaml = require("lyaml")
            local d = lyaml.load("a: 1")
            assert(d.a == 1)
        ]])
    end)
