-- Projectum Lunare Xmake Repository - LuaExpat Package
-- Category: Parsing, Data Formats & Templates
-- XML Expat parsing for the Lua language
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("luaexpat")
    set_homepage("https://lunarmodules.github.io/luaexpat")
    set_description("XML Expat parsing for the Lua language.")
    set_license("MIT")

    add_urls("https://github.com/lunarmodules/luaexpat/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/lunarmodules/luaexpat.git")

    add_versions("1.5.2", "89d83f2141edec31be576425637216928221918fe95dc3854d1b7fd4c627213f")
    add_versions("1.5.1", "7d455f154de59eb0b073c3620bc8b873f7f697b3f21a112e6ff8dc9fca6d0826")
    add_versions("1.5.0", "ae5710a948831b4260c2910f67d651e247dc3d48a228a31e1e78dd9e4a37aa48")
    add_versions("1.4.1", "d528060d45865b44bef7215ef8a440165b668f363a4af53358389f0315a8593c")
    add_versions("1.4.0", "aa40dbdfd314d489166e63ce1de4f484248272fb3b6fb35099ceaddc959ccca5")
    add_versions("1.3.0", "9906b1ec81ba141f4cd03e2c8f6c633b15e40b3d341c52a1ef97243e521cdce1")

    add_deps("expat")

    on_load(function (package)
        import("@addon.forge.lua.runtime").setup(package, {
            runtime = {"lua", "luajit"},
        })
    end)

    add_includedirs("include", "include/lxp")

    on_install(function (package)
        local targets = {}
        table.insert(targets, [[
            target("lxp")
                add_rules("forge.lua.module")
                add_packages("expat")
                add_includedirs("src")
                add_files("src/lxplib.c")
                add_headerfiles("src/*.h", {prefixdir = "lxp"})
        ]])

        for _, mod in ipairs({
            {name = "lxp.lom", file = "src/lxp/lom.lua"},
            {name = "lxp.totable", file = "src/lxp/totable.lua"},
            {name = "lxp.threat", file = "src/lxp/threat.lua"},
        }) do
            if os.isfile(mod.file) then
                table.insert(targets, string.format([[
                    target("%s")
                        add_rules("forge.lua.module")
                        add_packages("lua")
                        add_files("%s")
                ]], mod.name, mod.file))
            end
        end

        io.writefile("xmake.lua", string.format([[
            add_requires("expat")

            %s
        ]], table.concat(targets, "\n")))

        import("@addon.forge.lua.module").install_project(package)
    end)

    on_test(function (package)
        if package:is_plat("linux", "macosx", "bsd") and not package:config("shared") then
            return
        end
        import("@addon.forge.lua.module").lua_test(package, [[
            local lxp = require("lxp")
            assert(lxp and lxp._VERSION)
            local lom = require("lxp.lom")
            assert(lom and lom.parse)
            local doc, err = lom.parse("<root><item id='1'>test</item></root>")
            assert(doc and doc.tag == "root", err)
        ]])
    end)
