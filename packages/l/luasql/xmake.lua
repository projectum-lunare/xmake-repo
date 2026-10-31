-- Projectum Lunare Xmake Repository - luasql Package
-- Database connectivity for Lua
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("luasql")
    set_homepage("https://lunarmodules.github.io/luasql/")
    set_description("Database connectivity for Lua.")
    set_license("MIT")

    add_urls("https://github.com/lunarmodules/luasql/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/lunarmodules/luasql.git")

    add_versions("2.8.1", "4c5c890b53c5c085329e6d152f1f711c4bbc79234f85ed4371646802c91093a4")
    add_versions("2.8.0", "d568ef516f53ef28e21bf3008169c54ed301e476baadb47d61bfbe6f10de1129")
    add_versions("2.7.0", "15de59f0ea1a2ab205a11e0115d760f8e0c3fee0d3fcc37f52e326a53236e0c7")
    add_versions("2.6.0", "8ec445c58fa6148be759080c08f37baea5c3fa84f766197db9bf9c8edb6f8e60")
    add_versions("2.5.0", "666482b6ed1d4ca4317db2345c46dc0fc54a39c8cfd14e34f1a83595864b0ae4")

    add_configs("sqlite3", {description = "Enable SQLite3 driver", default = true, type = "boolean"})
    add_configs("postgres", {description = "Enable PostgreSQL driver", default = false, type = "boolean"})
    add_configs("mysql", {description = "Enable MySQL driver", default = false, type = "boolean"})
    add_configs("odbc", {description = "Enable ODBC driver", default = false, type = "boolean"})

    add_deps("lua")
    add_deps("forge master", {kind = "addon"})

    add_includedirs("include", "include/luasql")

    on_load(function (package)
        if package:config("sqlite3") then
            package:add("deps", "sqlite3")
        end
        if package:config("postgres") then
            package:add("deps", "libpq")
        end
        if package:config("mysql") then
            package:add("deps", "mysql")
        end
    end)

    on_install(function (package)
        local targets = {}
        local requires = {'add_requires("lua")'}

        if package:config("sqlite3") then
            table.insert(requires, 'add_requires("sqlite3")')
            table.insert(targets, string.format([[
                target("luasql.sqlite3")
                    add_rules("forge.lua.module")
                    add_packages("sqlite3")
                    add_includedirs("src")
                    add_defines("LUASQL_VERSION_NUMBER=\"%s\"")
                    add_files("src/luasql.c", "src/ls_sqlite3.c")
                    add_headerfiles("src/luasql.h", {prefixdir = "luasql"})
            ]], package:version_str()))
        end

        if package:config("postgres") then
            table.insert(requires, 'add_requires("libpq")')
            table.insert(targets, string.format([[
                target("luasql.postgres")
                    add_rules("forge.lua.module")
                    add_packages("libpq")
                    add_includedirs("src")
                    add_defines("LUASQL_VERSION_NUMBER=\"%s\"")
                    add_files("src/luasql.c", "src/ls_postgres.c")
                    add_headerfiles("src/luasql.h", {prefixdir = "luasql"})
            ]], package:version_str()))
        end

        if package:config("mysql") then
            table.insert(requires, 'add_requires("mysql")')
            table.insert(targets, string.format([[
                target("luasql.mysql")
                    add_rules("forge.lua.module")
                    add_packages("mysql")
                    add_includedirs("src")
                    add_defines("LUASQL_VERSION_NUMBER=\"%s\"")
                    add_files("src/luasql.c", "src/ls_mysql.c")
                    add_headerfiles("src/luasql.h", {prefixdir = "luasql"})
            ]], package:version_str()))
        end

        if package:config("odbc") then
            table.insert(targets, string.format([[
                target("luasql.odbc")
                    add_rules("forge.lua.module")
                    add_includedirs("src")
                    add_defines("LUASQL_VERSION_NUMBER=\"%s\"")
                    add_files("src/luasql.c", "src/ls_odbc.c")
                    if is_plat("windows", "mingw") then
                        add_syslinks("odbc32")
                    else
                        add_syslinks("odbc")
                    end
                    add_headerfiles("src/luasql.h", {prefixdir = "luasql"})
            ]], package:version_str()))
        end

        io.writefile("xmake.lua", string.format([[
            add_rules("mode.release", "mode.debug")
            %s
            includes("@addon/forge/forge.lua")

            %s
        ]], table.concat(requires, "\n"), table.concat(targets, "\n")))

        import("@addon.forge.lua.module").install_project(package)
    end)

    on_test(function (package)
        if package:is_plat("linux", "macosx", "bsd") and not package:config("shared") then
            return
        end
        if package:config("sqlite3") then
            import("@addon.forge.lua.module").lua_test(package, [[
                local luasql = require("luasql.sqlite3")
                assert(luasql and luasql.sqlite3)
                local env = luasql.sqlite3()
                assert(env)
                local conn = env:connect(":memory:")
                assert(conn)
                conn:execute("CREATE TABLE t (x INT);")
                conn:execute("INSERT INTO t VALUES (42);")
                local cur = conn:execute("SELECT x FROM t;")
                local row = cur:fetch({}, "a")
                assert(row and tonumber(row.x) == 42)
                cur:close()
                conn:close()
                env:close()
            ]])
        end
    end)
