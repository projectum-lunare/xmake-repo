-- Projectum Lunare Xmake Repository - lua-protobuf Package
-- Category: Parsing, Data Formats & Serialization
-- Fast Protocol Buffers implementation for Lua in pure C
-- Supported Platforms: Linux, macOS, BSD, Windows, Haiku

package("lua-protobuf")
    set_homepage("https://github.com/starwing/lua-protobuf")
    set_description("Fast Protocol Buffers (Google Protobuf) implementation for Lua in pure C.")
    set_license("MIT")

    add_urls("https://github.com/starwing/lua-protobuf/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/starwing/lua-protobuf.git")

    add_versions("0.6.0", "466b7baaaabc036cba8c5060736a2761cc3ef18de6f9d42efcf778b9df2e0e59")
    add_versions("0.5.3", "54feb9c48e13304e50a4177976b66c1ad395364c500bf00cbf9e3cb59c36ed91")

    on_load(function (package)
        import("@addon.recudo.lua.runtime").setup(package, {
            runtime = {"lua", "luajit"},
        })
    end)

    on_install(function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            target("pb")
                add_rules("recudo.lua.module")
                add_files("pb.c")
                add_headerfiles("pb.h")
        ]])
        import("@addon.recudo.lua.module").install_project(package)
    end)

    on_test(function (package)
        if package:config("shared") then
            import("@addon.recudo.lua.module").lua_test(package, [[
                local pb = require("pb")
                assert(type(pb.pack) == "function")
                assert(type(pb.unpack) == "function")
                local packed = pb.pack("varint", 12345)
                local val = pb.unpack("varint", packed)
                assert(val == 12345)
            ]])
        end
    end)
