-- Projectum Lunare Xmake Repository - LuaCov Package
-- Simple coverage analysis tool for Lua scripts
-- Supported Platforms: All platforms supporting Lua (POSIX, Windows, Vintage, Embedded)

package("luacov")
    set_homepage("https://lunarmodules.github.io/luacov/")
    set_description("Coverage analysis tool for Lua scripts.")
    set_license("MIT")

    add_urls("https://github.com/lunarmodules/luacov/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/lunarmodules/luacov.git")

    add_versions("v0.17.0", "791a4a93a21b7288b1555cda8b7ad1ee0540ea606bd5dcc1028e76eeaec0e3d3")
    add_versions("v0.16.0", "0396d48fd12dd7dacf8bd3778d15ef17218e701f4a3c2f36e4e2a64b60db1736")
    add_versions("v0.15.0", "19ebe0fdd5dd05ab63d5192371dcf272f2c7ccea5366e98fee440a2f30e021d8")

    add_deps("lua")

    on_load(function (package)
        package:addenv("PATH", "bin")
        package:addenv("LUA_PATH", "share/lua/?.lua")
        package:addenv("LUA_PATH", "share/lua/?/init.lua")
        package:mark_as_pathenv("LUA_PATH")
    end)

    on_install(function (package)
        os.mkdir(package:installdir("share/lua"))
        os.cp("src/luacov.lua", package:installdir("share/lua"))
        os.cp("src/luacov", package:installdir("share/lua"))

        os.mkdir(package:installdir("bin"))
        os.cp("src/bin/luacov", package:installdir("bin"))
        local binfile = package:installdir("bin/luacov")
        if not package:is_plat("windows") then
            try { function() os.runv("chmod", {"+x", binfile}) end }
        else
            io.writefile(package:installdir("bin/luacov.cmd"), "@echo off\r\nlua \"%~dp0\\luacov\" %*\r\n")
        end
    end)

    on_test(function (package)
        if not package:is_cross() then
            local envs = {}
            local lua_path = os.getenv("LUA_PATH")
            if lua_path then
                if not package:is_plat("windows") and not package:is_plat("mingw") then
                    lua_path = lua_path:gsub(":", ";")
                end
                if not lua_path:endswith(";;") then
                    lua_path = lua_path .. ";;"
                end
                envs.LUA_PATH = lua_path
            end
            os.vrunv("lua", {"-e", "local luacov = require('luacov'); assert(luacov)"}, {envs = envs})
            os.vrunv("luacov", {"--help"}, {envs = envs})
        end
    end)
