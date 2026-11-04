-- Projectum Lunare Xmake Repository - luaposix Package
-- Category: System, POSIX & OS Interfaces
-- Complete POSIX binding for Lua (unistd, dirent, fcntl, signal, sys/stat, poll, etc.)
-- Supported Platforms: Linux, macOS, BSD, Haiku

package("luaposix")
    set_homepage("https://github.com/luaposix/luaposix")
    set_description("A comprehensive Lua binding for POSIX APIs based on IEEE Std 1003.1.")
    set_license("MIT")

    add_urls("https://github.com/luaposix/luaposix/archive/refs/tags/v$(version).tar.gz")
    add_urls("https://github.com/luaposix/luaposix.git")

    add_versions("36.3", "82cd9a96c41a4a3205c050206f0564ff4456f773a8f9ffc9235ff8f1907ca5e6")

    if is_plat("linux") then
        add_syslinks("crypt")
    end

    on_load(function (package)
        import("@addon.recudo.lua.runtime").setup(package, {
            runtime = {"lua", "luajit"},
            default = "lua",
            version = ">=5.1 <=5.4",
        })
        if package:is_plat("linux") then
            package:add("syslinks", "crypt")
        end
    end)

    on_install("linux", "macosx", "bsd", "haiku", function (package)
        local lua_pkg = package:dep("lua") or package:dep("luajit")
        local lua_bin = "lua"
        local lua_inc = ""
        if lua_pkg then
            local bindir = lua_pkg:installdir("bin")
            if bindir and os.isfile(path.join(bindir, "lua")) then
                lua_bin = path.join(bindir, "lua")
            end
            lua_inc = lua_pkg:installdir("include")
        end

        local inst_lib = path.join(package:installdir(), "lib/lua")
        local inst_lua = path.join(package:installdir(), "share/lua")

        local args_common = {
            "build-aux/luke",
            "package=luaposix",
            "version=" .. package:version_str(),
            "CC=" .. (package:build_getenv("cc") or "gcc"),
            "LD=" .. (package:build_getenv("ld") or "gcc"),
            "LUA_INCDIR=" .. lua_inc,
            "LIB_EXTENSION=so",
            "OBJ_EXTENSION=o",
            "INST_LIBDIR=" .. inst_lib,
            "INST_LUADIR=" .. inst_lua,
        }

        local args_all = table.join(args_common, {"all"})
        os.vrunv(lua_bin, args_all)

        local args_install = table.join(args_common, {"install"})
        os.vrunv(lua_bin, args_install)
    end)

    on_test(function (package)
        if package:config("shared") then
            import("@addon.recudo.lua.module").lua_test(package, [[
                local posix = require("posix")
                assert(posix.version)
                assert(type(posix.errno) == "table")
                assert(type(posix.unistd) == "table")
            ]])
        end
    end)
