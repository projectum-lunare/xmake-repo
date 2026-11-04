-- Projectum Lunare Xmake Repository - Lua Package
-- Category: Runtimes & Core Language
-- Enhanced with retro-computing, embedded and C89 patches
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("lua")
    set_homepage("https://lua.org/")
    set_description("A powerful, efficient, lightweight, embeddable scripting language.")
    set_license("MIT")

    add_urls("https://www.lua.org/ftp/lua-$(version).tar.gz", {version = function (version)
        return version:sub(2)
    end})
    add_urls("https://github.com/lua/lua.git")

    add_versions("v5.5.1", "1c4b4068d67061f2a2231ad2b5422e77acea1487ea9890f6320af614f4373dce")
    add_versions("v5.5.0", "57ccc32bbbd005cab75bcc52444052535af691789dba2b9016d5c50640d68b3d")
    add_versions("v5.4.8", "4f18ddae154e793e46eeab727c59ef1c0c0c2b744e7b94219710d76f530629ae")
    add_versions("v5.4.7", "9fbf5e28ef86c69858f6d3d34eccc32e911c1a28b4120ff3e84aaa70cfbf1e30")
    add_versions("v5.4.6", "7d5ea1b9cb6aa0b59ca3dde1c6adcb57ef83a1ba8e5432c0ecd06bf439b3ad88")
    add_versions("v5.4.4", "164c7849653b80ae67bec4b7473b884bf5cc8d2dca05653475ec2ed27b9ebf61")
    add_versions("v5.4.3", "f8612276169e3bfcbcfb8f226195bfc6e466fe13042f1076cbde92b7ec96bbfb")
    add_versions("v5.4.2", "11570d97e9d7303c0a59567ed1ac7c648340cd0db10d5fd594c09223ef2f524f")
    add_versions("v5.4.1", "4ba786c3705eb9db6567af29c91a01b81f1c0ac3124fdbf6cd94bdd9e53cca7d")
    add_versions("v5.3.6", "fc5fd69bb8736323f026672b1b7235da613d7177e72558893a0bdcd320466d60")
    add_versions("v5.2.4", "b9e2e4aad6789b3b63a056d442f7b39f0ecfca3ae0f1fc0ae4e9614401b69f4b")
    add_versions("v5.2.3", "13c2fb97961381f7d06d5b5cea55b743c163800896fd5c5e2356201d3619002d")
    add_versions("v5.1.5", "2640fc56a795f29d28ef15e13c34a47e223960b0240e8cb0a82d9b0738695333")
    add_versions("v5.1.1", "c5daeed0a75d8e4dd2328b7c7a69888247868154acbda69110e97d4a6e17d1f0")

    add_deps("recudo master", {kind = "addon"})

    add_configs("c89",       {description = "Compile in strict ANSI C89 mode (LUA_USE_C89)", type = "boolean"})
    add_configs("32bits",    {description = "Enable 32-bit integers and floats (LUA_32BITS)", type = "boolean"})
    add_configs("no_parser", {description = "Disable compiler/parser (undump bytecode runtime only)", default = false, type = "boolean"})

    add_includedirs("include", "include/lua")
    if not is_plat("windows", "mingw", "wince", "dos", "kolibri", "wasm", "wasi") then
        add_syslinks("dl", "m")
    end

    add_bindirs("bin")

    on_install(function (package)
        local sourcedir = os.isdir("src") and "src/" or ""

        -- Toolchain selection and compat patches are recudo policy, resolved
        -- here where the toolchain is actually known (the definition scope
        -- has no is_toolchain() predicate, and the patch must land before
        -- the nested build is generated). The platform implies the toolchain
        -- (wince -> evc3, amiga/atari -> vbcc) or the consumer forces one on
        -- any platform via {configs = {evc3 = true}} / {configs = {vbcc = true}}.
        local tc = import("@addon.recudo.tool.patch").setup(package, {
            evc3 = {
                toolchain = "recudo.toolchain.evc3",
                platforms = "wince",
                c = {"89"},
            },
            vbcc = {
                toolchain = "recudo.toolchain.vbcc",
                c = {"89"},
                patches = {
                    {versions = ">=5.1.0 <5.2.0", patch = "patches/vbcc-5.1.patch"},
                    {versions = ">=5.4.4 <5.5.0", patch = "patches/vbcc-5.4.patch"},
                },
            },
            watcom = {
                toolchain = "recudo.toolchain.watcom",
                platforms = {"dos", "os2"},
                c = {"89"},
            },
            kolibrios = {
                c = {"89", "99"},
                patches = {
                    {versions = ">=5.4.0 <5.6.0", patch = "patches/kolibri.patch"},
                },
            },
            plan9 = {
                platforms = "plan9",
                patches = {
                    {versions = ">=5.4.0 <5.6.0", patch = "patches/plan9.patch"},
                },
            },
            wasm = {
                platforms = {"wasm", "wasi"},
                c = {"89", "99"},
                patches = {
                    {versions = ">=5.4.7 <5.6.0", patch = "patches/wasm.patch"},
                },
            },
        })

        -- C89 is a compiler limitation, not a platform one: the tools
        -- declare the C standards they support; an enabled tool without
        -- declared C99 support forces C89 mode. No recudo tool driving the
        -- build means the platform's own toolchain decides - modern C.
        local use_c89 = package:config("c89")
        if use_c89 == nil then
            use_c89 = false
            for _, name in ipairs(tc.tools) do
                local t = tc[name]
                if t.enabled and not (t.c and table.contains(t.c, "99")) then
                    use_c89 = true
                end
            end
        end

        -- word size is an ABI fact of the target arch, not of the platform
        local use_32b = package:config("32bits")
        if use_32b == nil then
            use_32b = package:is_arch("m68k.*", "i386", "x86", "mips.*", "ppc.*", "powerpc", "armv4.*", "armv5.*", "sh.*")
        end
        local no_parser = package:config("no_parser")

        local template = import("@addon.recudo.template")
        -- the nested build is rendered with recudo's own template engine:
        -- named fields and render-time control flow, no positional slots
        io.writefile("xmake.lua", template.render([[
            add_rules("mode.release", "mode.debug")
            <% if tc.addon then %>
            add_addons("recudo")
            includes("@addon/recudo/recudo.lua")
            <% end %>

            local sourcedir = "<%= sourcedir %>"
            target("lualib")
                set_kind("<%= kind %>")
                set_basename("lua")
                add_cxflags("-fvisibility=default", {force = true})
                add_headerfiles(sourcedir .. "*.h", {prefixdir = "lua"})
                add_headerfiles(sourcedir .. "lua.hpp", {prefixdir = "lua"})
                add_headerfiles(sourcedir .. "*.h")
                add_headerfiles(sourcedir .. "lua.hpp")
                add_files(sourcedir .. "*.c|lua.c|luac.c|onelua.c<% if no_parser then %>|lcode.c|llex.c|lparser.c<% end %>")
                add_defines("LUA_COMPAT_5_3")

                <% if use_c89 then %>
                add_defines("LUA_USE_C89")
                <% end %>
                <% if use_32b then %>
                add_defines("LUA_32BITS")
                <% end %>
                <% if no_parser then %>
                add_defines("LUA_NO_PARSER")
                <% end %>

                if is_plat("linux", "bsd", "cross") then
                    add_defines("LUA_USE_LINUX", "LUA_DL_DLOPEN")
                elseif is_plat("macosx", "iphoneos") then
                    add_defines("LUA_USE_MACOSX", "LUA_DL_DYLD")
                elseif is_plat("windows", "mingw") then
                    if is_kind("shared") then
                        add_defines("LUA_BUILD_AS_DLL", {public = true})
                    end
                elseif is_plat("wince") then
                    add_defines("UNDER_CE=300", "_WIN32_WCE=300")
                elseif is_plat("kolibri") then
                    add_defines("__KOLIBRIOS__")
                elseif is_plat("plan9") then
                    add_defines("_POSIX_SOURCE", "_PLAN9_SOURCE", "_BSD_EXTENSION")
                elseif is_plat("wasm", "wasi") then
                    add_defines("_WASI_EMULATED_SIGNAL", "_WASI_EMULATED_PROCESS_CLOCKS")
                end

            <% if tc.evc3.enabled then %>
                add_rules("<%= tc.evc3.toolchain %>", {override = true})
                set_values("<%= tc.evc3.toolchain %>.compat", "c89")
            <% end %>
            <% if tc.vbcc.enabled then %>
                add_rules("<%= tc.vbcc.toolchain %>", {override = true})
                set_values("<%= tc.vbcc.toolchain %>.math", "msoft")
                add_defines("LUA_USE_VBCC")
            <% end %>
            <% if tc.watcom.enabled then %>
                add_rules("<%= tc.watcom.toolchain %>", {override = true})
            <% end %>

            target("lua")
                set_enabled(<%= has_interpreter %>)
                set_kind("binary")
                add_files(sourcedir .. "lua.c")
                add_deps("lualib")
                if is_plat("linux", "bsd", "cross") then
                    add_ldflags("-Wl,-E")
                    add_rpathdirs("$ORIGIN/../lib")
                    if not is_kind("shared") then
                        add_ldflags("-Wl,--whole-archive", "-llua", "-Wl,--no-whole-archive")
                    end
                elseif is_plat("macosx") then
                    add_rpathdirs("@executable_path/../lib")
                end
                if not is_plat("windows", "mingw", "wince", "dos", "kolibri", "wasm", "wasi") then
                    add_syslinks("dl")
                end
        ]], {
            tc = tc,
            sourcedir = sourcedir,
            kind = package:config("shared") and "shared" or "static",
            use_c89 = use_c89,
            use_32b = use_32b,
            no_parser = no_parser,
            has_interpreter = not (package:is_cross() or no_parser or package:is_plat("wasm", "wasi")),
        }))

        local configs = {}
        if package:config("shared") then
            configs.kind = "shared"
        end

        import("package.tools.xmake").install(package, configs)
        os.cp(sourcedir .. "*.h", package:installdir("include"))
        os.trycp(sourcedir .. "lua.hpp", package:installdir("include"))
    end)

    on_test(function (package)
        if not package:is_cross() and not package:config("no_parser") and not package:is_plat("wasm", "wasi") then
            os.vrun("lua -e \"print('Projectum Lunare Lua ready!')\"")
        end
        assert(package:has_cfuncs("lua_getinfo", {includes = "lua/lua.h"}))
        assert(package:has_cfuncs("lua_getinfo", {includes = "lua.h"}))
    end)
