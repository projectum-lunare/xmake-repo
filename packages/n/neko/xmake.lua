-- Projectum Lunare Xmake Repository - NekoVM Package
-- Category: Languages, Compilers & Virtual Machines
-- Lightweight dynamic virtual machine and language by Haxe Foundation
-- Supported Platforms: Linux, macOS, Windows

package("neko")
    set_homepage("https://nekovm.org/")
    set_description("Neko is a high-level dynamically typed programming language and lightweight virtual machine.")
    set_license("MIT")

    add_urls("https://github.com/HaxeFoundation/neko/archive/refs/tags/v$(version).tar.gz", {version = function (version) return version:gsub("%.", "-") end})
    add_urls("https://github.com/HaxeFoundation/neko.git")
    add_versions("2.4.1", "702282028190dffa2078b00cca515b8e2ba889186a221df2226d2b6deb3ffaca")

    add_configs("regexp", {description = "Build with Perl-compatible regex support (regexp.ndll)", default = true, type = "boolean"})
    add_configs("sqlite", {description = "Build with SQLite support (sqlite.ndll)", default = true, type = "boolean"})
    add_configs("nekoml", {description = "Build NekoML compiler and tools", default = true, type = "boolean"})
    add_configs("jit", {description = "Enable JIT compiler", default = true, type = "boolean"})
    add_configs("ssl", {description = "Build with SSL/TLS support (ssl.ndll)", default = false, type = "boolean"})
    add_configs("mysql", {description = "Build with MySQL/MariaDB support (mysql.ndll)", default = false, type = "boolean"})
    add_configs("ui", {description = "Build with GTK3 UI support (ui.ndll)", default = false, type = "boolean"})
    add_configs("apache", {description = "Build with Apache HTTP server modules (mod_neko, mod_tora)", default = false, type = "boolean"})

    add_deps("cmake")
    add_deps("bdwgc", "zlib")

    on_load(function (package)
        if package:config("regexp") then
            package:add("deps", "pcre2")
        end
        if package:config("sqlite") then
            package:add("deps", "sqlite3")
        end
        if package:config("ssl") then
            package:add("deps", "mbedtls 3.x")
        end
        if package:config("mysql") then
            package:add("deps", "mariadb-connector-c")
        end
        if package:config("ui") and package:is_plat("linux", "bsd") then
            package:add("deps", "gtk3")
        end
        if package:config("apache") then
            package:add("deps", "apr")
        end
    end)

    add_bindirs("bin")
    add_includedirs("include")
    add_linkdirs("lib", "lib64")
    add_links("neko")

    on_install(function (package)
        local configs = {
            "-DRUN_LDCONFIG=OFF",
            "-DWITH_REGEXP=" .. (package:config("regexp") and "ON" or "OFF"),
            "-DWITH_SQLITE=" .. (package:config("sqlite") and "ON" or "OFF"),
            "-DWITH_NEKOML=" .. (package:config("nekoml") and "ON" or "OFF"),
            "-DNEKO_JIT_DISABLE=" .. (package:config("jit") and "OFF" or "ON"),
            "-DWITH_SSL=" .. (package:config("ssl") and "ON" or "OFF"),
            "-DWITH_MYSQL=" .. (package:config("mysql") and "ON" or "OFF"),
            "-DWITH_UI=" .. (package:config("ui") and "ON" or "OFF"),
            "-DWITH_APACHE=" .. (package:config("apache") and "ON" or "OFF")
        }

        if package:config("ssl") then
            local mbedtls = package:dep("mbedtls")
            if mbedtls then
                table.insert(configs, "-DMBEDTLS_ROOT=" .. mbedtls:installdir())
            end
        end

        if package:config("mysql") then
            local mariadb = package:dep("mariadb-connector-c")
            if mariadb then
                table.insert(configs, "-DMARIADB_CONNECTOR_INCLUDE_DIR=" .. path.join(mariadb:installdir(), "include", "mariadb"))
            end
        end

        import("package.tools.cmake").install(package, configs)

        local bindir = package:installdir("bin")
        local nekodir = package:installdir("lib/neko")
        if not os.isdir(nekodir) then
            nekodir = package:installdir("lib64/neko")
        end
        if os.isdir(nekodir) then
            for _, f in ipairs(os.files(path.join(nekodir, "*"))) do
                os.cp(f, bindir)
            end
        end

        package:addenv("NEKOPATH", bindir)
        package:addenv("PATH", bindir)
    end)

    on_test(function (package)
        local neko = path.join(package:installdir("bin"), "neko" .. (is_host("windows") and ".exe" or ""))
        local nekoc = path.join(package:installdir("bin"), "nekoc" .. (is_host("windows") and ".exe" or ""))
        os.vrunv(neko, {"-version"})
        local test_neko = path.join(os.tmpdir(), "test_neko_smoke.neko")
        local test_n = path.join(os.tmpdir(), "test_neko_smoke.n")
        io.writefile(test_neko, '$print("hello from neko\\n");')
        os.vrunv(nekoc, {test_neko})
        os.vrunv(neko, {test_n})
        os.rm(test_neko)
        os.rm(test_n)

        if package:config("nekoml") then
            local nekoml = path.join(package:installdir("bin"), "nekoml" .. (is_host("windows") and ".exe" or ""))
            if os.isexec(nekoml) then
                os.vrun(nekoml)
            end
        end
    end)
