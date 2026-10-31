-- Projectum Lunare Xmake Repository - lumen Package
-- Category: Data Structures, Concurrency & Utilities
-- Simple concurrent task scheduling and multitasking environment for Lua
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("lumen")
    set_homepage("https://github.com/xopxe/Lumen")
    set_description("Simple concurrent task scheduling and multitasking environment for Lua.")
    set_license("MIT")

    add_urls("https://github.com/xopxe/Lumen/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/xopxe/Lumen.git")

    add_versions("v1.0", "240ae43da36ad291746a23a5c40f9e08665701ecfa80d6a0e6dbbf25737b4cb7")

    add_deps("lua")
    add_deps("forge master", {kind = "addon"})

    on_install(function (package)
        io.writefile("lumen.lua", [[
return {
    sched = require("sched"),
    mutex = require("mutex"),
    pipes = require("pipes"),
    stream = require("stream"),
    catalog = require("catalog"),
    log = require("log"),
}
]])
        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            includes("@addon/forge/forge.lua")

            target("lumen")
                add_rules("forge.lua.module")
                set_values("forge.lua.rootdir", os.projectdir())
                add_files("catalog.lua", "log.lua", "mutex.lua", "pipes.lua", "sched.lua", "stream.lua", "lumen.lua")
                add_files("tasks/*.lua")
                add_files("lib/*.lua")
        ]])
        import("@addon.forge.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.forge.lua.module").lua_test(package, "local sched = require('sched'); assert(sched.new_task); local lumen = require('lumen'); assert(lumen.sched)")
    end)
