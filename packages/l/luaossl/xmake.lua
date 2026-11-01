-- Projectum Lunare Xmake Repository - luaossl Package
-- Category: Networking, Web & Services
-- Most comprehensive OpenSSL binding in the Lua universe
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("luaossl")
    set_homepage("https://github.com/wahern/luaossl")
    set_description("Most comprehensive OpenSSL binding in the Lua universe.")
    set_license("MIT")

    add_urls("https://github.com/wahern/luaossl/archive/refs/tags/rel-$(version).tar.gz")
    add_urls("https://github.com/wahern/luaossl.git")

    add_versions("20260910", "f6c2ed1007df7214bfdfa2f11a1f2128698119c99fa1efb776ce846f7bd198a8")
    add_versions("20250929", "2f695aea5f0bc0b9b32d3de56fffc5d41630f30bdd7e15bd68ce1f4bd3e8f61e")
    add_versions("20220711", "f16c4cd2c880f270c1c73daa0a4bfdd11ae3155b92a2086863731e06d241300b")

    add_deps("openssl")

    on_load(function (package)
        import("@addon.forge.lua.runtime").setup(package, {
            runtime = {"lua", "luajit"},
        })
    end)

    on_install(function (package)
        if os.isfile("config.h.guess") then
            os.cp("config.h.guess", "src/config.h")
        end

        for _, filepath in ipairs(os.files("src/openssl*.lua")) do
            local filename = path.filename(filepath)
            local stem = filename:gsub("%.lua$", "")
            local parts = {}
            for part in stem:gmatch("[^.]+") do
                table.insert(parts, part)
            end
            local dest = path.join("lua", table.concat(parts, "/") .. ".lua")
            os.mkdir(path.directory(dest))
            os.cp(filepath, dest)
        end

        io.writefile("xmake.lua", [[
            add_requires("openssl")

            target("_openssl")
                add_rules("forge.lua.module")
                add_packages("openssl")
                add_includedirs("src")
                add_defines("HAVE_CONFIG_H")
                add_cxflags("-Wno-incompatible-pointer-types")
                add_files("src/openssl.c")

            target("luaossl")
                add_rules("forge.lua.module")
                add_files("lua/**.lua")
        ]])
        import("@addon.forge.lua.module").install_project(package)
    end)

    on_test(function (package)
        if package:is_plat("linux", "macosx", "bsd", "windows", "mingw") and not package:config("shared") then
            return
        end
        import("@addon.forge.lua.module").lua_test(package, [[
            local hmac = require("openssl.hmac")
            assert(hmac)
            local ctx = hmac.new("secret", "sha1")
            assert(ctx)
        ]])
    end)
