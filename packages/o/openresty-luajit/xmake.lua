-- Projectum Lunare Xmake Repository - openresty-luajit Package
-- Category: Runtimes & Core Language
-- OpenResty's Branch of LuaJIT 2 with string.buffer, table.new/clear and GC64 support
-- Supported Platforms: Linux, macOS, BSD, Windows

package("openresty-luajit")
    set_homepage("https://github.com/openresty/luajit2")
    set_description("OpenResty's Branch of LuaJIT 2 with string.buffer, table.new/clear and GC64 support.")
    set_license("MIT")

    add_urls("https://github.com/openresty/luajit2/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/openresty/luajit2.git")

    add_versions("v2.1-20261023", "46ec00b6ba6261890a7d185c48f848e5e6b7a2909fc39ac80f407d1dcbfc74b2")
    add_versions("v2.1-20261021", "8a2a60eb1d86bdc9cf5b4347f404e211445111e5e80cac40050c997c51002833")
    add_versions("v2.1-20261015", "b2f395142ae67255c77695c3974eb2377e7d03004bfe26f9a5e523f395d83557")

    add_configs("lua52compat", {description = "Enable Lua 5.2 compatibility mode", default = true, type = "boolean"})
    add_configs("gc64",        {description = "Enable GC64 mode for 64-bit architectures", default = true, type = "boolean"})

    add_includedirs("include/luajit-2.1", "include")
    add_bindirs("bin")

    if not is_plat("windows", "mingw") then
        add_syslinks("dl", "m")
    end

    on_load(function (package)
        package:addenv("PATH", "bin")
        if package:config("shared") then
            package:addenv("PATH", "lib")
        end
    end)

    on_install("linux", "macosx", "bsd", function (package)
        local xcflags = {}
        if package:config("lua52compat") then
            table.insert(xcflags, "-DLUAJIT_ENABLE_LUA52COMPAT")
        end
        if package:config("gc64") and package:is_arch("x86_64", "x64", "arm64", "arm64-v8a", "mips64") then
            table.insert(xcflags, "-DLUAJIT_ENABLE_GC64")
        end

        local argv = {
            "PREFIX=" .. package:installdir(),
            "MULTILIB=lib",
        }
        if #xcflags > 0 then
            table.insert(argv, "XCFLAGS=" .. table.concat(xcflags, " "))
        end
        if package:config("shared") == false then
            table.insert(argv, "BUILDMODE=static")
        else
            table.insert(argv, "BUILDMODE=mixed")
        end

        import("package.tools.make").build(package, argv)
        import("package.tools.make").make(package, table.join({"install"}, argv))

        local bindir = package:installdir("bin")
        local incdir = package:installdir("include")
        local libdir = package:installdir("lib")

        -- Provide 'lua' binary copy in bin
        if os.isdir(bindir) then
            local luajit_bin = path.join(bindir, "luajit")
            local lua_bin = path.join(bindir, "lua")
            if os.isfile(luajit_bin) and not os.isfile(lua_bin) then
                os.cp(luajit_bin, lua_bin)
            end
        end

        -- Mirror headers into include/ for convenience
        local subinc = path.join(incdir, "luajit-2.1")
        if os.isdir(subinc) then
            for _, header in ipairs(os.files(path.join(subinc, "*.h*"))) do
                local dst = path.join(incdir, path.filename(header))
                if not os.isfile(dst) then
                    os.cp(header, dst)
                end
            end
        end

        -- Ensure standard library copies exist in lib/
        if os.isdir(libdir) then
            local so51 = path.join(libdir, "libluajit-5.1.so")
            if os.isfile(so51) then
                local luajit_so = path.join(libdir, "libluajit.so")
                local lua_so = path.join(libdir, "liblua.so")
                if not os.isfile(luajit_so) then
                    os.cp(so51, luajit_so)
                end
                if not os.isfile(lua_so) then
                    os.cp(so51, lua_so)
                end
            end
            local a51 = path.join(libdir, "libluajit-5.1.a")
            if os.isfile(a51) then
                local luajit_a = path.join(libdir, "libluajit.a")
                local lua_a = path.join(libdir, "liblua.a")
                if not os.isfile(luajit_a) then
                    os.cp(a51, luajit_a)
                end
                if not os.isfile(lua_a) then
                    os.cp(a51, lua_a)
                end
            end
        end
    end)

    on_install("windows", function (package)
        os.cd("src")
        local msvc_args = {"amalg"}
        if package:config("lua52compat") then
            table.insert(msvc_args, "lua52compat")
        end
        if not package:config("gc64") then
            table.insert(msvc_args, "nogc64")
        end
        if package:config("shared") == false then
            table.insert(msvc_args, "static")
        end
        os.vrunv("msvcbuild.bat", msvc_args)

        local bindir = package:installdir("bin")
        local incdir = package:installdir("include")
        local libdir = package:installdir("lib")

        os.mkdir(bindir)
        os.mkdir(incdir)
        os.mkdir(libdir)

        os.cp("luajit.exe", path.join(bindir, "luajit.exe"))
        os.cp("luajit.exe", path.join(bindir, "lua.exe"))

        for _, f in ipairs({"lua51.dll", "luajit.dll"}) do
            if os.isfile(f) then
                os.cp(f, bindir)
                os.cp(f, libdir)
            end
        end

        for _, f in ipairs({"lua51.lib", "luajit.lib"}) do
            if os.isfile(f) then
                os.cp(f, libdir)
            end
        end

        for _, f in ipairs({"lua.h", "luajit.h", "luaconf.h", "lualib.h", "lauxlib.h", "lua.hpp"}) do
            if os.isfile(f) then
                os.cp(f, incdir)
                local sub = path.join(incdir, "luajit-2.1")
                os.mkdir(sub)
                os.cp(f, sub)
            end
        end
    end)

    on_test(function (package)
        if package:is_plat(os.host()) and not package:is_cross() then
            os.vrun("luajit -v")
            os.vrun("luajit -e \"local buf = require('string.buffer'); assert(buf.new); local tnew = require('table.new'); local tclr = require('table.clear'); local t = tnew(10, 0); tclr(t); print('OpenResty LuaJIT 2.1 verified successfully!')\"")
        end
        assert(package:check_csnippets("int main() { lua_State* L = luaL_newstate(); return 0; }", {includes = {"lua.h", "lauxlib.h", "lualib.h"}}))
    end)
