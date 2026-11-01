package("love")
    set_homepage("https://love2d.org")
    set_description("LÖVE is an awesome 2D game framework for Lua.")
    set_license("Zlib")

    add_urls("https://github.com/love2d/love/releases/download/$(version)/love-$(version)-linux-src.tar.gz")

    add_versions("11.5", "066e0843f71aa9fd28b8eaf27d41abb74bfaef7556153ac2e3cf08eafc874c39")
    add_versions("11.4", "e32feecaf5f4f210242a4b5f26cdf9ce9014bfde18d51286f643bb7fe51f5369")
    add_versions("11.3", "649f0db7750ca121e4de7b60208703661052356df35f4cfad490b1ba14dd1455")

    add_configs("mpg123", {description = "Enable mpg123 mp3 support.", default = true, type = "boolean"})

    add_deps("libsdl2", "freetype", "openal-soft", "zlib", "libmodplug", "libvorbis", "libogg", "theora")

    on_load(function (package)
        import("@addon.forge.lua.runtime").setup(package, {
            runtime = {"luajit", "lua"},
            default = "luajit",
        })

        package:addenv("PATH", "bin")
        if package:is_plat("linux") then
            package:addenv("LD_LIBRARY_PATH", "lib")
        elseif package:is_plat("macosx") then
            package:addenv("DYLD_LIBRARY_PATH", "lib")
        end
        if package:config("mpg123") then
            package:add("deps", "mpg123")
        end
    end)

    on_install("linux", "macosx", "bsd", function (package)
        local rt = package:config("runtime") or "luajit"
        local use_luajit = (rt == "luajit")
        local lua_dep = package:dep(use_luajit and "luajit" or "lua")
        local luaversion = "5.1"
        if lua_dep and lua_dep:version() then
            luaversion = lua_dep:version():major() .. "." .. lua_dep:version():minor()
        end

        local configs = {
            "--bindir=" .. package:installdir("bin"),
            "--libdir=" .. package:installdir("lib"),
            "--with-lua=" .. (use_luajit and "luajit" or "lua"),
            "--with-luaversion=" .. (use_luajit and "5.1" or luaversion),
        }

        if package:config("shared") then
            table.insert(configs, "--enable-shared")
            table.insert(configs, "--disable-static")
        else
            table.insert(configs, "--disable-shared")
            table.insert(configs, "--enable-static")
        end

        if package:config("mpg123") then
            table.insert(configs, "--enable-mpg123")
        else
            table.insert(configs, "--disable-mpg123")
        end

        local sdl2 = package:dep("libsdl2")
        if sdl2 and not sdl2:is_system() then
            table.insert(configs, "--with-sdl-prefix=" .. sdl2:installdir())
        end

        local autoconf = import("package.tools.autoconf")
        local envs = autoconf.buildenvs(package)

        local local_pkgconfig = path.join(os.curdir(), ".pkgconfig")
        os.mkdir(local_pkgconfig)

        local theora = package:dep("theora")
        if theora then
            local theora_dir = theora:installdir()
            local pc_content = string.format([[prefix=%s
exec_prefix=${prefix}
libdir=${exec_prefix}/lib
includedir=${prefix}/include

Name: theoradec
Description: Theora video compression format
Version: %s
Libs: -L${libdir} -ltheoradec -logg
Cflags: -I${includedir}
]], theora_dir, tostring(theora:version() or "1.1.1"))
            io.writefile(path.join(local_pkgconfig, "theoradec.pc"), pc_content)
        end

        local lua = package:dep("lua")
        if lua then
            local lua_dir = lua:installdir()
            local ver = tostring(lua:version() or luaversion)
            local pc_content = string.format([[prefix=%s
exec_prefix=${prefix}
libdir=${exec_prefix}/lib
includedir=${prefix}/include

Name: Lua
Description: Lua language engine
Version: %s
Libs: -L${libdir} -llua -ldl -lm
Cflags: -I${includedir} -I${includedir}/lua
]], lua_dir, ver)
            io.writefile(path.join(local_pkgconfig, "lua.pc"), pc_content)
            io.writefile(path.join(local_pkgconfig, "lua" .. luaversion .. ".pc"), pc_content)
            local clean_ver = luaversion:gsub("%.", "")
            io.writefile(path.join(local_pkgconfig, "lua" .. clean_ver .. ".pc"), pc_content)
        end

        if envs.PKG_CONFIG_PATH and envs.PKG_CONFIG_PATH ~= "" then
            envs.PKG_CONFIG_PATH = local_pkgconfig .. ":" .. envs.PKG_CONFIG_PATH
        else
            envs.PKG_CONFIG_PATH = local_pkgconfig
        end

        envs.LIBS = (envs.LIBS and (envs.LIBS .. " ") or "") .. "-lvorbis -logg -ldl -lm"

        autoconf.install(package, configs, {envs = envs})
    end)

    on_test(function (package)
        if not package:is_cross() then
            local out = os.iorunv("love", {"--version"})
            assert(out and out:find("LOVE " .. package:version():major() .. "." .. package:version():minor(), 1, true), "unexpected version: " .. tostring(out))
        end
    end)
