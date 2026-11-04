-- Projectum Lunare Xmake Repository - lua-cmsgpack Package
-- Category: Parsing, Data Formats & Serialization
-- Fast self-contained MessagePack serializer for Lua
-- Supported Platforms: Linux, macOS, BSD, Windows, Haiku

package("lua-cmsgpack")
    set_homepage("https://github.com/antirez/lua-cmsgpack")
    set_description("Fast self-contained MessagePack serializer and deserializer for Lua.")
    set_license("BSD-2-Clause")

    add_urls("https://github.com/antirez/lua-cmsgpack/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/antirez/lua-cmsgpack.git")

    add_versions("0.4.0", "ed00bbcce9c6589aad71b96d5bc88b7581186b3abd38ae887cb1f265a19fa3e5")

    on_load(function (package)
        import("@addon.recudo.lua.runtime").setup(package, {
            runtime = {"lua", "luajit"},
        })
    end)

    on_install(function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            target("cmsgpack")
                add_rules("recudo.lua.module")
                add_files("lua_cmsgpack.c")
        ]])
        import("@addon.recudo.lua.module").install_project(package)
    end)

    on_test(function (package)
        if package:config("shared") then
            import("@addon.recudo.lua.module").lua_test(package, [[
                local mp = require("cmsgpack")
                local data = { name = "Lua", fast = true, count = 42 }
                local packed = mp.pack(data)
                local unpacked = mp.unpack(packed)
                assert(unpacked.name == "Lua")
                assert(unpacked.fast == true)
                assert(unpacked.count == 42)
            ]])
        end
    end)
