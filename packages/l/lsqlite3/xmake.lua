-- Projectum Lunare Xmake Repository - lsqlite3 Package
-- Category: Databases & Storage
-- Database binding for SQLite3 in Lua with full SQLite3 API support
-- Supported Platforms: Linux, macOS, BSD, Windows, Haiku

package("lsqlite3")
    set_homepage("http://lua.sqlite.org/")
    set_description("A binding for Lua to the SQLite3 database library with full API support.")
    set_license("MIT")

    add_urls("https://lua.sqlite.org/home/tarball/v$(version)/lsqlite3-$(version).tar.gz")

    add_versions("0.9.7", "1500bc16064366caa2b97a36029b85801f6a97a76eabaa140d5df3462e04278a")
    add_versions("0.9.6", "f6772453d3ea6cdf1af9f5c03952415f501a444c0b969fafda7bb60e7b30f212")

    on_load(function (package)
        import("@addon.recudo.lua.runtime").setup(package, {
            runtime = {"lua", "luajit"},
        })
        package:add("deps", "sqlite3")
    end)

    on_install(function (package)
        io.writefile("xmake.lua", string.format([[
            add_rules("mode.release", "mode.debug")
            add_requires("sqlite3")
            target("lsqlite3")
                add_rules("recudo.lua.module")
                add_packages("sqlite3")
                add_defines("LSQLITE_VERSION=\"%s\"")
                add_files("lsqlite3.c")
        ]], package:version_str()))
        import("@addon.recudo.lua.module").install_project(package)
    end)

    on_test(function (package)
        if package:config("shared") then
            import("@addon.recudo.lua.module").lua_test(package, [[
                local sqlite3 = require("lsqlite3")
                local db = assert(sqlite3.open_memory())
                assert(db:exec("CREATE TABLE t (id INTEGER, val TEXT); INSERT INTO t VALUES (1, 'hello');") == sqlite3.OK)
                local count = 0
                for row in db:nrows("SELECT * FROM t") do
                    assert(row.val == "hello")
                    count = count + 1
                end
                assert(count == 1)
                db:close()
            ]])
        end
    end)
