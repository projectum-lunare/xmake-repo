-- Projectum Lunare Xmake Repository - LuaCov LCOV Reporter Package
-- Category: Testing, Code Quality & Documentation
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
    add_deps("forge master", {kind = "addon"})
    set_kind("library", {headeronly = true})

    on_install(function (package)
        io.replace("luacov/reporter/lcov.lua", 'pcall(require "openssl.digest")', 'pcall(require, "openssl.digest")', {plain = true})
        io.writefile("xmake.lua", [[
            target("luacov.reporter.lcov")
                add_rules("forge.lua.module")
                add_files("luacov/reporter/lcov.lua")
        ]])
        import("@addon.forge.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.forge.lua.module").lua_test(package, "assert(require('luacov.reporter.lcov').LcovReporter)")
    end)
