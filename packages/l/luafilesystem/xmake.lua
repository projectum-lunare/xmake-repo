-- Projectum Lunare Xmake Repository - LuaFileSystem Package
-- Category: System, Hardware & Native Bindings
-- File System Library for the Lua Language
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("luafilesystem")
    set_homepage("https://github.com/lunarmodules/luafilesystem")
    set_description("File System Library for the Lua Language.")
    set_license("MIT")

    add_urls("https://github.com/lunarmodules/luafilesystem/archive/refs/tags/v$(version).tar.gz", {version = function (version)
        return version:gsub("%.", "_")
    end})
    add_urls("https://github.com/lunarmodules/luafilesystem.git")

    add_versions("1.9.0", "1142c1876e999b3e28d1c236bf21ffd9b023018e336ac25120fb5373aade1450")
    add_versions("1.8.0", "16d17c788b8093f2047325343f5e9b74cccb1ea96001e45914a58bbae8932495")
    add_versions("1.7.0.2", "23b4883aeb4fb90b2d0f338659f33a631f9df7a7e67c54115775a77d4ac3cc59")
    add_versions("1.6.3", "11c7b1fc2e560c0a521246b84e6257138d97dddde5a19e405714dbabcb9436ca")

    on_load(function (package)
        import("@addon.forge.lua.runtime").setup(package, {
            runtime = {"lua", "luajit"},
        })
    end)

    add_includedirs("include")

    on_install(function (package)
        io.writefile("xmake.lua", [[
            target("lfs")
                add_rules("forge.lua.module")
                add_files("src/lfs.c")
                add_headerfiles("src/(lfs.h)")
        ]])
        import("@addon.forge.lua.module").install_project(package)
    end)

    on_test(function (package)
        if package:is_plat("linux", "macosx", "bsd") and not package:config("shared") then
            -- Lua modules built statically cannot be dlopen'd by standalone lua
            return
        end
        import("@addon.forge.lua.module").lua_test(package, [[
            local lfs = require("lfs")
            assert(lfs and lfs._VERSION)
            local current = assert(lfs.currentdir())
            assert(type(lfs.attributes(current)) == "table")
        ]])
    end)
