-- Projectum Lunare Xmake Repository - redis-lua Package
-- Pure Lua client library for the Redis key-value storage system
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("redis-lua")
    set_homepage("https://github.com/nrk/redis-lua")
    set_description("A Lua client library for the Redis key-value storage system.")
    set_license("MIT")

    add_urls("https://github.com/nrk/redis-lua/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/nrk/redis-lua.git")

    add_versions("v2.0.4", "5eb6cb7cd0eda659cef7c231e43cd5f491cbd04804034d1c80134a1604e5cb5e")
    add_versions("v2.0.3", "3985492db5a8e2f5f58ad69d22c62238a659bc4532ff58c620ae1ae457e20c1d")

    add_deps("lua")
    add_deps("luasocket")
    add_deps("forge master", {kind = "addon"})

    on_install(function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            includes("@addon/forge/forge.lua")

            target("redis")
                add_rules("forge.lua.module")
                add_files("src/redis.lua")
        ]])
        import("@addon.forge.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.forge.lua.module").lua_test(package, "local redis = require('redis'); assert(redis._VERSION)")
    end)
