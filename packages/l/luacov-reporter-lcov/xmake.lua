-- Projectum Lunare Xmake Repository - LuaCov LCOV Reporter Package
-- An LCOV reporter for LuaCov to export coverage for Codecov, Coveralls and IDEs
-- Supported Platforms: All platforms supporting Lua (POSIX, Windows, Vintage, Embedded)

package("luacov-reporter-lcov")
    set_homepage("https://github.com/daurnimator/luacov-reporter-lcov")
    set_description("A luacov reporter for use with lcov.")
    set_license("MIT")

    add_urls("https://github.com/daurnimator/luacov-reporter-lcov/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/daurnimator/luacov-reporter-lcov.git")

    add_versions("v0.2", "e450b209e54eea225546e8bdc5bb10bb9ba2e6d26200cfd7818031f6ef3c4640")
    add_versions("v0.1", "a5c0edda950868da6a6177fd8ff2284477b200a1942e3a9fc0af6437c07e8dd5")

    add_deps("lua", "luacov")

    on_load(function (package)
        package:addenv("LUA_PATH", "share/lua/?.lua")
        package:addenv("LUA_PATH", "share/lua/?/init.lua")
        package:mark_as_pathenv("LUA_PATH")
    end)

    on_install(function (package)
        io.replace("luacov/reporter/lcov.lua", 'pcall(require "openssl.digest")', 'pcall(require, "openssl.digest")', {plain = true})
        os.mkdir(package:installdir("share/lua"))
        os.cp("luacov", package:installdir("share/lua"))
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
            os.vrunv("lua", {"-e", "local lcov = require('luacov.reporter.lcov'); assert(lcov.LcovReporter)"}, {envs = envs})
        end
    end)
