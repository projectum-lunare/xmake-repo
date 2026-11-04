-- Projectum Lunare Xmake Repository - hc Package
-- Category: Game Development (Math & Physics)
-- General purpose 2D collision detection with SAT and GJK
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("hc")
    set_homepage("https://github.com/vrld/HC")
    set_description("General purpose 2D collision detection with Separating Axis Theorem (SAT) and GJK.")
    set_license("MIT")

    add_urls("https://github.com/vrld/HC/archive/$(version).tar.gz", {version = function (version)
        local v = tostring(version)
        if v == "0.1.0" or v == "0.1-1" then
            return "92a51492f323ec5360f56bed0aebac30dbbd52ac"
        end
        return v
    end})
    add_urls("https://github.com/vrld/HC.git")

    add_versions("0.1.0", "312c086af029156cabffd04d66c09904da68f0431b2cedecfbf9b524a42a7ebc")

    add_patches("0.1.0", "patches/0.1.0/lua54-compat.patch", "a5647d32326cb9a2e06d3fe9a7104b317e673ff932c1693fff9b477721f6066a")

    on_load(function (package)
        import("@addon.recudo.lua.runtime").setup(package, {
            runtime = {"lua", "luajit"},
            default = "lua",
        })
    end)

    on_install(function (package)
        os.mkdir("hc")
        for _, file in ipairs(os.files("*.lua")) do
            os.cp(file, "hc/")
        end
        os.mkdir("hardoncollider")
        for _, file in ipairs(os.files("*.lua")) do
            os.cp(file, "hardoncollider/")
        end
        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            includes("@addon/recudo/recudo.lua")

            target("hc")
                add_rules("recudo.lua.module")
                add_packages("lua")
                add_files("hc/**.lua")
                add_files("hardoncollider/**.lua")
        ]])
        import("@addon.recudo.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.recudo.lua.module").lua_test(package, [[
            local HC = require("hc")
            local c1 = HC.circle(100, 100, 10)
            local c2 = HC.circle(105, 100, 10)
            local c3 = HC.circle(300, 300, 10)
            local colliding, dx, dy = c1:collidesWith(c2)
            assert(colliding)
            assert(not c1:collidesWith(c3))
        ]])
    end)
