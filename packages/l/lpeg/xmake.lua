-- Projectum Lunare Xmake Repository - LPeg Package
-- Parsing Expression Grammars for Lua
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("lpeg")
    set_homepage("https://www.inf.puc-rio.br/~roberto/lpeg/")
    set_description("Pattern-Matching for Lua that uses Parsing Expression Grammars (PEGs).")
    set_license("MIT")

    add_urls("https://www.inf.puc-rio.br/~roberto/lpeg/lpeg-$(version).tar.gz", {version = function (version)
        return version:sub(2)
    end})
    add_urls("https://github.com/roberto-ieru/LPeg.git")

    add_versions("v1.1.0", "4b155d67d2246c1ffa7ad7bc466c1ea899bbc40fef0257cc9c03cecbaed4352a")
    add_versions("v1.0.2", "48d66576051b6c78388faad09b70493093264588fcd0f258ddaab1cdd4a15ffe")

    add_deps("lua")
    if is_plat("dos", "os2", "wince") then
        add_deps("forge", {kind = "addon"})
    end

    add_includedirs("include", "include/lpeg")

    on_load(function (package)
        package:addenv("LUA_PATH", "share/lua/?.lua;;")
        package:mark_as_pathenv("LUA_PATH")
        if package:config("shared") then
            local ext = package:is_plat("windows", "mingw") and ".dll" or ".so"
            package:addenv("LUA_CPATH", "lib/?" .. ext .. ";;")
            package:mark_as_pathenv("LUA_CPATH")
        end
    end)

    on_install(function (package)
        local use_c89 = package:is_plat("wince", "dos", "os2", "amiga", "atari", "kolibri", "plan9")
        local use_32b = package:is_plat("wince", "dos", "os2", "amiga", "atari", "kolibri", "plan9")
                     or package:is_arch("m68k.*", "i386", "x86", "mips.*", "ppc.*", "powerpc", "armv4.*", "armv5.*", "sh.*")

        local luadep = package:dep("lua")
        local luainfo = luadep and luadep:fetch()
        local lua_includes = {}
        if luainfo then
            for _, inc in ipairs(table.wrap(luainfo.includedirs)) do
                local inc_norm = inc:gsub("\\", "/")
                table.insert(lua_includes, format('add_includedirs("%s")', inc_norm))
                table.insert(lua_includes, format('add_includedirs("%s/lua")', inc_norm))
            end
            for _, inc in ipairs(table.wrap(luainfo.sysincludedirs)) do
                local inc_norm = inc:gsub("\\", "/")
                table.insert(lua_includes, format('add_sysincludedirs("%s")', inc_norm))
                table.insert(lua_includes, format('add_sysincludedirs("%s/lua")', inc_norm))
            end
        end

        os.cp(path.join(package:scriptdir(), "port/lpeg.h"), "lpeg.h")

        io.writefile("xmake.lua", format([[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            if is_plat("dos", "os2", "wince") then
                add_addons("forge")
                includes("@addon/forge/forge.lua")
            end

            target("lpeg")
                set_kind("%s")
                set_basename("lpeg")
                add_files("lpcap.c", "lpcode.c", "lpcset.c", "lpprint.c", "lptree.c", "lpvm.c")
                add_headerfiles("*.h", {prefixdir = "lpeg"})
                add_headerfiles("*.h")
                add_packages("lua")
                %s

                %s
                %s

                if is_plat("wince") then
                    add_rules("forge.evc3", {override = true})
                elseif is_plat("dos", "os2") then
                    add_rules("forge.watcom", {override = true})
                elseif is_plat("windows", "mingw") and is_kind("shared") then
                    add_rules("utils.symbols.export_all")
                    add_shflags("/export:luaopen_lpeg")
                end
        ]],
            package:config("shared") and "shared" or "static",
            table.concat(lua_includes, "\n                "),
            use_c89 and 'add_defines("LUA_USE_C89")' or "",
            use_32b and 'add_defines("LUA_32BITS")' or ""))

        local configs = {}
        if package:config("shared") then
            configs.kind = "shared"
        end

        import("package.tools.xmake").install(package, configs)
        os.trycp("re.lua", package:installdir("share/lua"))
        os.trycp("re.lua", package:installdir("lib"))
    end)

    on_test(function (package)
        assert(package:check_csnippets({test = [[
            #include <lpeg/lpeg.h>
            void test(void) {
                luaopen_lpeg(0);
            }
        ]]}))
        assert(package:check_csnippets({test = [[
            #include <lpeg.h>
            void test(void) {
                luaopen_lpeg(0);
            }
        ]]}))
    end)
