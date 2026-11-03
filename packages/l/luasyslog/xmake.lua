-- Projectum Lunare Xmake Repository - luasyslog Package
-- Category: System, Hardware & Native Bindings
-- Syslog logging for Lua
-- Supported Platforms: Linux, macOS, BSD, POSIX

package("luasyslog")
    set_homepage("https://github.com/lunarmodules/luasyslog")
    set_description("Syslog logging addon for LuaLogging and standalone syslog access.")
    set_license("MIT")

    add_urls("https://github.com/lunarmodules/luasyslog/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/lunarmodules/luasyslog.git")

    add_versions("2.0.1", "166ddad9c6ab304d4793242493a516ab8c33c768724f798ea7c955631b29a72e")
    add_versions("2.0.0", "187fc1916b32f72a6ccd0e79e9425f6eb25c94df10f0a404b1b7961f919d5803")

    add_deps("lua")
    add_deps("lualogging")
    add_deps("recudo master", {kind = "addon"})

    on_install("linux", "macosx", "bsd", "cross", function (package)
        os.mkdir("logging")
        os.cp("syslog.lua", "logging/syslog.lua")

        io.writefile("xmake.lua", [[
            target("lsyslog")
                add_rules("recudo.lua.module")
                add_files("lsyslog.c")

            target("logging.syslog")
                add_rules("recudo.lua.module")
                add_files("logging/syslog.lua")
        ]])
        import("@addon.recudo.lua.module").install_project(package)
    end)

    on_test(function (package)
        if package:is_plat("linux", "macosx", "bsd", "windows", "mingw") and not package:config("shared") then
            return
        end
        import("@addon.recudo.lua.module").lua_test(package, [[
            local lsyslog = require("lsyslog")
            assert(lsyslog and lsyslog.open)
            local syslog = require("logging.syslog")
            assert(syslog)
        ]])
    end)
