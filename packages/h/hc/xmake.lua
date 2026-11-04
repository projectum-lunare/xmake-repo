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

    on_load(function (package)
        import("@addon.recudo.lua.runtime").setup(package, {
            runtime = {"lua", "luajit"},
            default = "lua",
        })
    end)

    on_install(function (package)
        io.replace("polygon.lua", "i = ((i-1 + q) % #other.vertices) + 1\n\t\tret[#ret+1] = other.vertices[i].x\n\t\tret[#ret+1] = other.vertices[i].y", "local idx = ((i-1 + q) % #other.vertices) + 1\n\t\tret[#ret+1] = other.vertices[idx].x\n\t\tret[#ret+1] = other.vertices[idx].y", {plain = true})

        for _, f in ipairs({"class.lua", "gjk.lua", "init.lua", "polygon.lua"}) do
            local content = io.readfile(f)
            if not content:find("table.unpack", 1, true) then
                io.writefile(f, "local unpack = rawget(_G, 'unpack') or rawget(table, 'unpack')\n" .. content)
            end
        end

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
