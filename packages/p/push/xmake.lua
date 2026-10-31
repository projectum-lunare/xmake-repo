-- Projectum Lunare Xmake Repository - push Package
-- Lua library implementing knockout.js-like observable properties
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("push")
    set_homepage("https://github.com/sgraf812/push")
    set_description("Lua library implementing knockout.js-like observable properties.")
    set_license("MIT")

    add_urls("https://github.com/sgraf812/push/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/sgraf812/push.git")

    add_versions("v0.1", "d8f46e8c2a5c8cefcf9facd13d9a090678136ad21738643d663541143ed06e1f")

    add_deps("lua")
    add_deps("forge master", {kind = "addon"})

    on_install(function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            includes("@addon/forge/forge.lua")

            target("push")
                add_rules("forge.lua.module")
                add_files("src/push.lua")
        ]])
        import("@addon.forge.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.forge.lua.module").lua_test(package, "local push = require('push'); local p = push.property(42); assert(p() == 42)")
    end)
