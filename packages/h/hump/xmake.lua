-- Projectum Lunare Xmake Repository - hump Package
-- Category: Game Engines, Creative Coding & LÖVE
-- Lightweight game development utilities for LÖVE (camera, timer, vector, gamestate, class, signal)
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("hump")
    set_homepage("https://github.com/vrld/hump")
    set_description("Lightweight game development utilities for LÖVE (camera, timer, vector, gamestate, class, signal).")
    set_license("MIT")

    add_urls("https://github.com/vrld/hump/archive/$(version).tar.gz", {version = function (version)
        local v = tostring(version)
        if v == "0.4.2" or v == "0.4-2" then
            return "08937cc0ecf72d1a964a8de6cd552c5e136bf0d4"
        end
        return v
    end})
    add_urls("https://github.com/vrld/hump.git")

    add_versions("0.4.2", "442a7167eb9b33908e880b6c35cedce0eab22b86bf474f162312c867bc6eef25")
    add_versions("0.4-2", "442a7167eb9b33908e880b6c35cedce0eab22b86bf474f162312c867bc6eef25")
    add_versions("master", "08937cc0ecf72d1a964a8de6cd552c5e136bf0d4")

    add_deps("lua")
    add_deps("recudo master", {kind = "addon"})

    on_install(function (package)
        io.gsub("class.lua", "k = include_helper%(%{%}, k, seen%)", "local key = include_helper({}, k, seen)")
        io.gsub("class.lua", "if to%[k%] == nil then%s+to%[k%]", "if to[key] == nil then\n\t\t\tto[key]")
        io.gsub("gamestate.lua", "for k in pairs%(love%.handlers%) do", "for k in pairs(love and love.handlers or {}) do")

        io.writefile("init.lua", [[
return {
    camera = require("hump.camera"),
    class = require("hump.class"),
    gamestate = require("hump.gamestate"),
    signal = require("hump.signal"),
    timer = require("hump.timer"),
    vector = require("hump.vector"),
    vector_light = require("hump.vector-light"),
}
]])

        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            includes("@addon/recudo/recudo.lua")

            target("hump")
                add_rules("recudo.lua.module")
                add_packages("lua")
                add_files("init.lua")

            for _, mod in ipairs({
                {name = "hump.camera",       file = "camera.lua"},
                {name = "hump.class",        file = "class.lua"},
                {name = "hump.gamestate",    file = "gamestate.lua"},
                {name = "hump.signal",       file = "signal.lua"},
                {name = "hump.timer",        file = "timer.lua"},
                {name = "hump.vector",       file = "vector.lua"},
                {name = "hump.vector-light", file = "vector-light.lua"},
            }) do
                target(mod.name)
                    add_rules("recudo.lua.module")
                    add_packages("lua")
                    add_files(mod.file)
            end
        ]])
        import("@addon.recudo.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.recudo.lua.module").lua_test(package, [[
            local hump = require("hump")
            local Camera = require("hump.camera")
            local Timer = require("hump.timer")
            local Vector = require("hump.vector")
            local Class = require("hump.class")
            assert(hump.camera == Camera)
            assert(Camera)
            assert(Timer)
            assert(Vector)
            assert(Class)
        ]])
    end)
