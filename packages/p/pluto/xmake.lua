-- Projectum Lunare Xmake Repository - Pluto Package
-- Category: Languages, Compilers & Dialects
-- A modern general-purpose superset of Lua 5.5
-- Supported Platforms: Linux, macOS, Windows

package("pluto")
    set_homepage("https://pluto-lang.org/")
    set_description("Pluto is a general-purpose, superset of Lua with a focus on ease of use, code readability, and performance.")
    set_license("MIT")

    add_urls("https://github.com/PlutoLang/Pluto/archive/refs/tags/$(version).tar.gz",
             "https://github.com/PlutoLang/Pluto.git")
    add_versions("0.13.2", "60d171e91504dad0c1f57676d97c0fb2c33d990bb68a70e0ea7de742bcc1112f")

    add_bindirs("bin")
    add_includedirs("include")
    add_linkdirs("lib")

    if is_plat("linux", "bsd") then
        add_syslinks("dl", "resolv", "m")
    elseif is_plat("windows", "mingw") then
        add_syslinks("ws2_32", "bcrypt", "dnsapi")
    end

    on_install("linux", "macosx", "bsd", function (package)
        local plat = "generic"
        if package:is_plat("linux") then
            plat = "linux"
        elseif package:is_plat("macosx") then
            plat = "macosx"
        elseif package:is_plat("bsd") then
            plat = "bsd"
        end
        local configs = {plat}
        import("package.tools.make").build(package, configs)
        import("package.tools.make").make(package, {"install", "INSTALL_TOP=" .. package:installdir()})
    end)

    on_install("windows", function (package)
        local bindir = package:installdir("bin")
        local libdir = package:installdir("lib")
        local incdir = package:installdir("include")
        os.mkdir(bindir)
        os.mkdir(libdir)
        os.mkdir(incdir)

        if package:is_plat("mingw") or package:has_tool("cc", "gcc") then
            import("package.tools.make").build(package, {"mingw"})
            os.cp("src/pluto.exe", bindir)
            os.cp("src/plutoc.exe", bindir)
            if os.isfile("src/pluto.dll") then
                os.cp("src/pluto.dll", bindir)
                os.cp("src/pluto.dll", libdir)
            end
        else
            -- MSBuild using official Pluto.sln
            local configs_pluto = {"Pluto.sln", "-p:Configuration=pluto"}
            local configs_plutoc = {"Pluto.sln", "-p:Configuration=plutoc"}
            local configs_lib = {"Pluto.sln", "-p:Configuration=" .. (package:config("shared") and "dll" or "static lib")}

            import("package.tools.msbuild").build(package, configs_pluto)
            import("package.tools.msbuild").build(package, configs_plutoc)
            import("package.tools.msbuild").build(package, configs_lib)

            -- Copy output binaries
            for _, f in ipairs(os.files("out/**.exe")) do
                os.cp(f, bindir)
            end
            for _, f in ipairs(os.files("out/**.dll")) do
                os.cp(f, bindir)
                os.cp(f, libdir)
            end
            for _, f in ipairs(os.files("out/**.lib")) do
                os.cp(f, libdir)
            end
        end

        -- Copy public headers
        os.cp("src/lua.h", incdir)
        os.cp("src/luaconf.h", incdir)
        os.cp("src/lualib.h", incdir)
        os.cp("src/lauxlib.h", incdir)
        os.cp("src/lua.hpp", incdir)
    end)

    on_test(function (package)
        os.vrun("pluto -v")
        os.vrun('pluto -e "class Foo end; print(\\"hello from pluto\\")"')
    end)
