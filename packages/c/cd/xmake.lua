-- Projectum Lunare Xmake Repository - CD Package
-- Category: System, Hardware & Native Bindings
-- Canvas Draw (CD) 2D Graphics Canvas Toolkit (Tecgraf/PUC-Rio)
-- Supported Platforms: Linux, macOS, Windows

package("cd")
    set_homepage("https://www.tecgraf.puc-rio.br/cd/")
    set_description("A 2D Graphics Canvas Draw Toolkit (Tecgraf/PUC-Rio).")
    set_license("MIT")

    add_urls("https://downloads.sourceforge.net/project/canvasdraw/$(version)/Docs%20and%20Sources/cd-$(version)_Sources.tar.gz")
    add_versions("5.14", "c44edc041131c9a6a42933c879a644d6bd828d60b28a4b855a9cde615fc5af4f")

    add_patches("5.14", path.join(os.scriptdir(), "patches", "5.14", "cdlua.patch"), "a620f4f24d7ecfdc6f2e77e2522030a4a3794a45896f9e66426323fb77c9f9f6")

    add_configs("lua", {description = "Build Lua bindings (cdlua and cdluaim)", default = true, type = "boolean"})

    add_includedirs("include", "include/cd")
    add_links("cdim", "cd")

    add_deps("im")

    if is_plat("linux", "macosx", "bsd") then
        add_syslinks("gtk-3", "gdk-3", "pangocairo-1.0", "pango-1.0", "cairo", "gobject-2.0", "glib-2.0", "fontconfig", "freetype", "m", "z")
    elseif is_plat("windows") then
        add_syslinks("gdi32", "user32", "comdlg32", "msimg32")
    end

    on_load(function (package)
        if package:config("lua") then
            package:add("deps", "lua")
            package:add("deps", "forge master", {kind = "addon"})
        end
    end)

    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {lua = package:config("lua")}
        import("package.tools.xmake").install(package, configs)

        if package:config("lua") then
            import("@addon.forge.lua.tree").apply_search_envs(package)
        end
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            #include <cd.h>
            void test() {
                const char* ver = cdVersion();
                (void)ver;
            }
        ]]}))

        if package:config("lua") then
            import("@addon.forge.lua.module").lua_test(package, [[
                local cd = require("cdlua")
                assert(cd.Version() ~= nil)
                local im = require("imlua")
                assert(im.Version() ~= nil)
                local cdluaim = require("cdluaim")
                local img = im.ImageCreate(100, 100, im.RGB, im.BYTE)
                assert(img ~= nil)
                local cnv = cd.CreateCanvas(cd.IMIMAGE, img)
                assert(cnv ~= nil)
                cnv:Activate()
                cnv:Foreground(cd.EncodeColor(255, 0, 0))
                cnv:Line(0, 0, 100, 100)
                cnv:Kill()
                img:Destroy()
            ]])
        end
    end)
