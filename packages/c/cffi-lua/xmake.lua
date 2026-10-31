-- Projectum Lunare Xmake Repository - cffi-lua Package
-- A portable C FFI for Lua 5.1+, based on libffi
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("cffi-lua")
    set_homepage("https://github.com/q66/cffi-lua")
    set_description("A portable C FFI for Lua 5.1+, based on libffi.")
    set_license("MIT")

    add_urls("https://github.com/q66/cffi-lua/archive/refs/tags/v$(version).tar.gz")
    add_urls("https://github.com/q66/cffi-lua.git")

    add_versions("0.2.4", "89e418e734c3628d4169fe5d237dff3f7769d0c42de5ed8b484a404f42cdc061")
    add_versions("0.2.3", "1d2577a62a843e5e6db35af1b58300d279b4df58eccef5e823441501f960d388")
    add_versions("0.2.2", "34fb4eea7a0abec2095f08596f604ac01c81b979bead7d2f5cb084b3e2b46cbc")
    add_versions("0.2.1", "c30080d6309167f86d1a96d3ee33f33ef52e884052b7feac140b8c52db10ad7a")
    add_versions("0.2.0", "2c499180f89c9813c8bd0b176bc11e61e1ecbf0e1f60278014a23ed88a33ca00")

    add_deps("lua")
    add_deps("libffi")
    add_deps("forge master", {kind = "addon"})

    if is_plat("linux", "bsd") then
        add_syslinks("dl")
    end

    on_install(function (package)
        local shared_libffi = package:dep("libffi") and package:dep("libffi"):config("shared")
        local extra_defs = ""
        if shared_libffi then
            extra_defs = 'add_defines("HAVE_LIBFFI_DLLIMPORT")'
        end

        io.writefile("xmake.lua", string.format([[
            add_rules("mode.release", "mode.debug")
            add_requires("lua", "libffi")
            includes("@addon/forge/forge.lua")

            target("cffi")
                add_rules("forge.lua.module")
                set_languages("c++14")
                add_files("src/*.cc")
                add_packages("libffi")
                if is_arch("mips.*", "ppc.*", "powerpc.*", "sparc.*", "s390x", "m68k.*") then
                    add_defines("FFI_BIG_ENDIAN")
                else
                    add_defines("FFI_LITTLE_ENDIAN")
                end
                if is_kind("shared") then
                    add_defines("CFFI_LUA_DLL")
                end
                if is_plat("windows", "mingw") then
                    %s
                else
                    add_syslinks("dl")
                end
        ]], extra_defs))
        import("@addon.forge.lua.module").install_project(package)
    end)

    on_test(function (package)
        if package:config("shared") then
            import("@addon.forge.lua.module").lua_test(package, [[
                local ffi = require("cffi")
                assert(ffi and ffi.os and ffi.arch)
            ]])
        else
            assert(package:check_cxxsnippets({test = [[
                struct lua_State;
                extern "C" int luaopen_cffi(struct lua_State *L);
                void test(void) {
                    luaopen_cffi(0);
                }
            ]]}, {configs = {languages = "c++14"}}))
        end
    end)
