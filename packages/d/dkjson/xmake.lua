-- Projectum Lunare Xmake Repository - dkjson Package
-- Category: Parsing, Data Formats & Templates
-- David Kolf's JSON module for Lua
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("dkjson")
    set_homepage("https://dkolf.de/dkjson-lua/")
    set_description("David Kolf's JSON module for Lua.")
    set_license("MIT")

    add_urls("https://dkolf.de/dkjson-lua/dkjson-$(version).tar.gz")

    add_versions("2.11", "7a169af681bc3be738111f38e6a80777a3203a602c1023afeaedaad2f22ee298")
    add_versions("2.10", "e8c79e06b5c485643396508f4c45e6d1eec685d08bfbe77042f41f38424d5b24")
    add_versions("2.9", "7ab7d28dc1b6bd15b8a9b179f6b88fb2ee67aea63cd40fd1baa83ce2adfe9a63")
    add_versions("2.8", "24e8cd3beb91c1c861eb7bb3fbc9bd418bbff9ad4aa5d0471816258236a31532")
    add_versions("2.7", "4c51a62102f2f6bdb76777f1db7360509b4a0116803588b4e8255f435af2395c")
    add_versions("2.6", "bd07ee4eb398aed6cf36f92423845399a5b46c15090990cc90e56d07c46f9773")
    add_versions("2.5", "552bde07d6eb95dc32423cc4c6f6fa40699611ef6ba96ba990fcd0e055b38a93")
    add_versions("2.4", "c3e206f37c4c4eb804958227fd29f7c72d53b433e84f46d9d10771d68b5f3cf3")
    add_versions("2.3", "c4314495619cbe0d2e47f3b0150cfed0a87d568e63811d8b201bd88c3f5347a1")


    on_load(function (package)
        import("@addon.recudo.lua.runtime").setup(package, {
            runtime = {"lua", "luajit"},
            default = "lua",
        })
    end)


    on_install(function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            includes("@addon/recudo/recudo.lua")

            target("dkjson")
                add_rules("recudo.lua.module")
                add_packages("lua")
                add_files("dkjson.lua")
        ]])
        import("@addon.recudo.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.recudo.lua.module").lua_test(package, [[
            local json = require("dkjson")
            local str = json.encode({ status = "ok" })
            local obj = json.decode(str)
            assert(obj and obj.status == "ok")
        ]])
    end)
