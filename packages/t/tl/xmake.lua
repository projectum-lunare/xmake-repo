-- Projectum Lunare Xmake Repository - Teal Package
-- Category: Languages, Compilers & Typecheckers
-- Teal, a typed dialect of Lua
-- Supported Platforms: All platforms supporting Lua (POSIX, Windows, Vintage, Embedded)

package("tl")
    set_homepage("https://github.com/teal-language/tl")
    set_description("Teal, a typed dialect of Lua.")
    set_license("MIT")

    add_urls("https://github.com/teal-language/tl/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/teal-language/tl.git")

    add_versions("v0.24.8", "8d7a143fd67d71dca5dad132a0e1443be6c013c54de2884adf4f3ed3b2cef022")
    add_versions("v0.24.7", "2fa3211c37fdc48f56fd76c14d95463f7bbf3cec3f71ebca39f0b653e937274c")
    add_versions("v0.24.6", "7f4f91f3667653dd5c1a2a273a0066fcf0ad8bbec1506b1a1619abf471408f7a")

    add_deps("lua")
    add_deps("argparse")
    add_deps("recudo master", {kind = "addon"})

    set_kind("library", {headeronly = true})
    add_bindirs("bin")

    on_install(function (package)
        io.replace("tl",
            'for entry in path:gmatch("[^;]+") do\n      entry = entry:gsub("%.", "%%.")',
            'for raw_entry in path:gmatch("[^;]+") do\n      local entry = raw_entry:gsub("%.", "%%.")',
            {plain = true})

        io.replace("tl",
            "package.path = save_package_path",
            "-- package.path = save_package_path",
            {plain = true})

        local argparse = package:dep("argparse")
        if argparse then
            local f = path.join(argparse:installdir(), "share/lua/argparse.lua")
            if not os.isfile(f) then
                f = path.join(argparse:installdir(), "lib/argparse.lua")
            end
            if os.isfile(f) then
                os.cp(f, "argparse.lua")
            end
        end

        io.writefile("xmake.lua", [[
            target("tl")
                add_rules("recudo.lua.module")
                add_files("tl.lua")
                after_install(function (target)
                    local bindir = path.join(target:installdir(), "bin")
                    os.mkdir(bindir)
                    os.cp("tl.lua", path.join(bindir, "tl.lua"))
                    if os.isfile("argparse.lua") then
                        os.cp("argparse.lua", path.join(bindir, "argparse.lua"))
                    end
                    if os.isfile("tl.tl") then
                        os.cp("tl.tl", path.join(target:installdir(), "share/lua/tl.tl"))
                        os.cp("tl.tl", path.join(target:installdir(), "lib/tl.tl"))
                    end
                end)

            target("tl.bin")
                add_rules("recudo.lua.bin")
                add_files("tl")
        ]])
        import("@addon.recudo.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.recudo.lua.module").lua_test(package, [[
            local tl = require("tl")
            assert(tl and tl.check)
            local syntax_tree, errors = tl.parse("local x: number = 10")
            assert(syntax_tree and #errors == 0)
            local output, gen_errs = tl.gen("local x: number = 10")
            assert(output and output:find("local x = 10", 1, true))
        ]])

        if not package:is_cross() then
            local tl_bin = path.join(package:installdir("bin"), "tl")
            if os.isexec(tl_bin) then
                local out = os.iorunv(tl_bin, {"--version"})
                assert(out and (out:find("Teal", 1, true) or out:find("0.", 1, true)), "unexpected tl version: " .. tostring(out))
            end
        end
    end)
