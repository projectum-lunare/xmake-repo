add_rules("mode.release", "mode.debug")

if is_plat("linux", "macosx", "bsd") then
    add_cflags("-Wno-incompatible-pointer-types")
end

option("lua")
    set_default(true)
    set_showmenu(true)
    set_description("Build Lua bindings (cdlua and cdluaim)")
option_end()

add_requires("im")
if has_config("lua") then
    add_requires("lua")
end

target("cd")
    set_kind("$(kind)")
    if not is_plat("windows") then
        add_cxflags("-fPIC")
    end
    add_includedirs("include", "src", "src/drv", "src/intcgm", "src/sim", "src/svg")
    add_headerfiles("include/(cd*.h)", "include/(wd*.h)")

    add_files(
        "src/cd.c",
        "src/wd.c",
        "src/wdhdcpy.c",
        "src/rgb2map.c",
        "src/cd_vectortext.c",
        "src/cd_active.c",
        "src/cd_attributes.c",
        "src/cd_bitmap.c",
        "src/cd_image.c",
        "src/cd_primitives.c",
        "src/cd_text.c",
        "src/cd_util.c",
        "src/svg/*.c",
        "src/intcgm/*.c",
        "src/minizip/*.c",
        "src/sim/*.c",
        "src/drv/cdcgm.c",
        "src/drv/cddebug.c",
        "src/drv/cddgn.c",
        "src/drv/cddxf.c",
        "src/drv/cdirgb.c",
        "src/drv/cdmf.c",
        "src/drv/cdpicture.c",
        "src/drv/cdpptx.c",
        "src/drv/pptx.c",
        "src/drv/cdps.c",
        "src/drv/cgm.c"
    )

    if is_plat("windows") then
        add_includedirs("src/win32")
        add_files("src/win32/*.c")
        add_defines("UNICODE")
        add_syslinks("gdi32", "user32", "comdlg32", "msimg32")
    else
        add_includedirs("src/cairo")
        add_files(
            "src/cairo/cdcairodbuf.c",
            "src/cairo/cdcairopdf.c",
            "src/cairo/cdcairosvg.c",
            "src/cairo/cdcairo.c",
            "src/cairo/cdcairoimg.c",
            "src/cairo/cdcairoirgb.c",
            "src/cairo/cdcairops.c",
            "src/cairo/cdcaironative_gdk.c",
            "src/cairo/cdcairoprn_gtk.c",
            "src/cairo/cdcairoplus.c",
            "src/gdk/cdgdkclp.c",
            "src/drv/cd0wmf.c",
            "src/drv/cd0emf.c"
        )
        add_defines("USE_GTK3", "GTK_DISABLE_DEPRECATED", "GDK_DISABLE_DEPRECATED", "GSEAL_ENABLE")
        add_cflags("$(shell pkg-config --cflags gtk+-3.0 cairo pangocairo fontconfig freetype2)", {force = true})
        add_includedirs("/usr/include/gtk-3.0/unix-print")
        add_syslinks("m", "z")
    end

target("cdim")
    set_kind("$(kind)")
    if not is_plat("windows") then
        add_cxflags("-fPIC")
    end
    add_deps("cd")
    add_packages("im")
    add_includedirs("include", "src")
    add_headerfiles("include/cdim.h")
    add_files("src/drv/cdim.c")

if has_config("lua") then
    target("cdlua")
        set_kind("shared")
        set_prefixname("")
        if not is_plat("windows") then
            add_cxflags("-fPIC")
        end
        add_deps("cd")
        add_packages("lua")
        add_includedirs("include", "src", "src/lua5")
        add_headerfiles("include/cdlua*.h")
        add_files(
            "src/lua5/cdlua5.c",
            "src/lua5/cdvoid5.c",
            "src/lua5/cdlua5ctx.c",
            "src/lua5/cdlua5_active.c",
            "src/lua5/cdlua5_canvas.c",
            "src/lua5/cdluacontextplus5.c"
        )
        if is_plat("linux", "macosx", "bsd") then
            add_syslinks("m")
            add_shflags("$(shell pkg-config --libs gtk+-3.0 cairo pangocairo fontconfig freetype2)")
        end

    target("cdluaim")
        set_kind("shared")
        set_prefixname("")
        if not is_plat("windows") then
            add_cxflags("-fPIC")
        end
        add_deps("cd", "cdim")
        add_packages("im", "lua")
        add_includedirs("include", "src", "src/lua5")
        add_headerfiles("include/cdluaim.h")
        add_files("src/lua5/cdluaim5.c")
        if is_plat("linux", "macosx", "bsd") then
            add_syslinks("m")
            add_shflags("$(shell pkg-config --libs gtk+-3.0 cairo pangocairo fontconfig freetype2)")
            add_shflags("-Wl,-rpath,$ORIGIN")
        end
        on_load(function (target)
            target:add("linkdirs", target:targetdir())
            local im = target:pkg("im")
            if im then
                target:add("linkdirs", im:installdir("lib"))
                if is_plat("windows") then
                    target:add("links", "imlua", "cdlua")
                else
                    target:add("shflags", "-l:cdlua.so", {force = true})
                    target:add("shflags", "-l:imlua.so", {force = true})
                    target:add("shflags", "-Wl,-rpath," .. im:installdir("lib"))
                end
            end
        end)
end
