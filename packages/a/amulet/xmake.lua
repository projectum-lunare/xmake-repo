-- Projectum Lunare Xmake Repository - amulet
-- Category: Game Engines & Creative Coding

package("amulet")
    set_homepage("http://www.amulet.xyz/")
    set_description("A Lua-based audio/visual game toolkit for small games, rapid prototyping and experimentation.")
    set_license("MIT")

    add_urls("https://github.com/ianmaclarty/amulet/archive/refs/tags/$(version).tar.gz")
    add_versions("v1.9.4", "fe11273c035e81e447c27382bfb1e6499c246eb9758f6613ab64eeb5ec15feb1")
    add_versions("v1.9.3", "3c49544ca9ad351012e934d9eeedbef3717a7a71748978ab93ca13290dcdf3fd")

    add_deps("libsdl2", "freetype")

    add_includedirs("include")
    add_links("amulet")

    if is_plat("linux", "bsd") then
        add_syslinks("GL", "dl", "m", "pthread")
    elseif is_plat("macosx") then
        add_frameworks("OpenGL", "Cocoa", "IOKit", "CoreAudio", "AudioToolbox", "AudioUnit", "AVFoundation", "CoreVideo", "CoreMedia")
        add_syslinks("m", "iconv")
    end

    on_load(function (package)
        import("@addon.forge.lua.runtime").setup(package, {
            runtime = {"lua", "luajit"},
            version = "5.1",
            default = "lua",
        })

        package:addenv("PATH", "bin")
        if package:is_plat("linux") then
            package:add("defines", package:is_arch("x86_64") and "AM_LINUX64" or "AM_LINUX32")
        elseif package:is_plat("macosx") then
            package:add("defines", "AM_OSX")
        elseif package:is_plat("windows") then
            package:add("defines", "AM_WINDOWS")
        end
    end)

    on_install("linux", "macosx", function (package)
        local configs = {}
        local rt = package:config("runtime") or "lua"
        table.insert(configs, "--runtime=" .. rt)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        if not package:is_cross() then
            local out = os.iorunv("amulet", {"version"})
            assert(out and out:find("Amulet", 1, true), "unexpected version: " .. tostring(out))

            assert(package:check_cxxsnippets({test = [[
                #include <lua.h>
                #include <am_engine.h>
                void test() {
                    am_set_custom_init_hook(0);
                }
            ]]}))
        end
    end)
