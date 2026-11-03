-- Projectum Lunare Xmake Repository - IUP Package
-- Category: System, Hardware & Native Bindings
-- Portable User Interface Toolkit (Tecgraf/PUC-Rio)
-- Supported Platforms: Linux, macOS, Windows

package("iup")
    set_homepage("https://www.tecgraf.puc-rio.br/iup/")
    set_description("A Multi-platform Toolkit for Building Graphical User Interfaces (Tecgraf/PUC-Rio).")
    set_license("MIT")

    add_urls("https://downloads.sourceforge.net/project/iup/$(version)/Docs%20and%20Sources/iup-$(version)_Sources.tar.gz")
    add_versions("3.30", "8b3105e17b3dd71b3abb137ebeba105b7828a3346655ff76527c8a148e5343e2")

    add_configs("lua", {description = "Build Lua bindings (iuplua, iupluacd, iupluaim, iupluacontrols, iupluaimglib)", default = true, type = "boolean"})

    add_includedirs("include", "include/iup")
    add_links("iupcontrols", "iupcd", "iupim", "iupimglib", "iup")

    add_deps("im", "cd")

    if is_plat("linux", "macosx", "bsd") then
        add_syslinks("gtk-3", "gdk-3", "gdk_pixbuf-2.0", "pangocairo-1.0", "pango-1.0", "cairo", "gobject-2.0", "glib-2.0", "fontconfig", "freetype", "X11", "m", "z")
    elseif is_plat("windows") then
        add_syslinks("gdi32", "user32", "comdlg32", "comctl32", "uuid", "ole32", "oleaut32")
    end

    on_load(function (package)
        import("@addon.recudo.lua.runtime").setup(package, {
            runtime = {"lua", "luajit"},
            default = "lua",
        })

        if package:config("lua") then
            package:add("deps", "lua")
            package:add("deps", "recudo master", {kind = "addon"})
        end
    end)

    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {lua = package:config("lua")}
        import("package.tools.xmake").install(package, configs)

        if package:config("lua") then
            import("@addon.recudo.lua.tree").apply_search_envs(package)
        end
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            #include <iup.h>
            void test() {
                IupOpen(0, (char***)0);
                IupClose();
            }
        ]]}))

        if package:config("lua") then
            import("@addon.recudo.lua.module").lua_test(package, [[
                local iup = require("iuplua")
                assert(iup._VERSION ~= nil)
                local cd = require("cdlua")
                local iupluacd = require("iupluacd")
                local im = require("imlua")
                local iupluaim = require("iupluaim")
                local iupluacontrols = require("iupluacontrols")
                local iupluaimglib = require("iupluaimglib")
                local btn = iup.button{title = "OK"}
                assert(btn ~= nil)
                local lbl = iup.label{title = "Hello IUP"}
                assert(lbl ~= nil)
                local vbox = iup.vbox{lbl, btn}
                assert(vbox ~= nil)
            ]])
        end
    end)
