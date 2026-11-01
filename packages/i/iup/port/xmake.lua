add_rules("mode.release", "mode.debug")

if is_plat("linux", "macosx", "bsd") then
    add_cflags("-Wno-incompatible-pointer-types")
end

option("lua")
    set_default(true)
    set_showmenu(true)
    set_description("Build Lua bindings (iuplua, iupluacd, iupluaim, iupluacontrols, iupluaimglib)")
option_end()

add_requires("im", "cd")
if has_config("lua") then
    add_requires("lua")
end

target("iup")
    set_kind("$(kind)")
    if not is_plat("windows") then
        add_cxflags("-fPIC")
    end
    add_includedirs("include", "src")
    add_headerfiles("include/(iup*.h)", "include/(iup*.hpp)")

    add_files("src/*.c")

    if is_plat("windows") then
        add_includedirs("src/win")
        add_files("src/win/*.c")
        add_defines("UNICODE", "_WIN32_WINNT=0x0601", "WINVER=0x0601", "NOTREEVIEW")
        add_syslinks("gdi32", "user32", "comdlg32", "comctl32", "uuid", "ole32", "oleaut32")
    else
        add_includedirs("src/gtk", "/usr/include/gtk-3.0/unix-print")
        add_files("src/gtk/iupgtk_*.c|iupgtk_draw_gdk.c")
        add_files("src/mot/iupunix_info.c")
        add_defines("USE_GTK3", "GTK_DISABLE_DEPRECATED", "GDK_DISABLE_DEPRECATED", "GSEAL_ENABLE")
        add_cflags("$(shell pkg-config --cflags gtk+-3.0 cairo pangocairo fontconfig freetype2)", {force = true})
        add_syslinks("m")
    end

target("iupcd")
    set_kind("$(kind)")
    if not is_plat("windows") then
        add_cxflags("-fPIC")
    end
    add_deps("iup")
    add_packages("cd")
    add_includedirs("include", "src", "srccd")
    add_headerfiles("include/iupdraw_cd.h")
    add_defines("CD_NO_OLD_INTERFACE")
    add_files("srccd/iup_cd.c", "srccd/iup_cdutil.c", "srccd/iup_draw_cd.c")

target("iupim")
    set_kind("$(kind)")
    if not is_plat("windows") then
        add_cxflags("-fPIC")
    end
    add_deps("iup")
    add_packages("im")
    add_includedirs("include", "src", "srcim")
    add_headerfiles("include/iupim.h")
    add_files("srcim/iup_im.c")

target("iupcontrols")
    set_kind("$(kind)")
    if not is_plat("windows") then
        add_cxflags("-fPIC")
    end
    add_deps("iup", "iupcd")
    add_packages("cd")
    add_includedirs("include", "src", "srccontrols", "srccontrols/matrix", "srccontrols/matrixex", "srccd")
    add_headerfiles("include/iupcontrols.h")
    add_files(
        "srccontrols/iup_controls.c",
        "srccontrols/iup_cells.c",
        "srccontrols/iup_matrixlist.c",
        "srccontrols/matrix/*.c",
        "srccontrols/matrixex/*.c"
    )

target("iupimglib")
    set_kind("$(kind)")
    if not is_plat("windows") then
        add_cxflags("-fPIC")
    end
    add_deps("iup")
    add_includedirs("include", "src", "srcimglib")
    add_headerfiles("include/iup_imglib.h")
    add_defines("IUP_IMGLIB_LARGE_ICON")
    add_files("srcimglib/iup_image_library.c", "srcimglib/iup_imglib_circleprogress.c")
    if is_plat("windows") then
        add_files(
            "srcimglib/iup_imglib_basewin32x32.c",
            "srcimglib/iup_imglib_logos48x48.c",
            "srcimglib/iup_imglib_logos32x32.c",
            "srcimglib/iup_imglib_iconswin48x48.c"
        )
    else
        add_defines("GTK3")
        add_files(
            "srcimglib/iup_imglib_basegtk324x24.c",
            "srcimglib/iup_imglib_iconsgtk348x48.c",
            "srcimglib/iup_imglib_logos48x48.c",
            "srcimglib/iup_imglib_logos32x32.c"
        )
    end

if has_config("lua") then
    target("iuplua")
        set_kind("shared")
        set_prefixname("")
        if not is_plat("windows") then
            add_cxflags("-fPIC")
        end
        add_deps("iup")
        add_packages("lua")
        add_defines("IUPLUA_USELH")
        add_includedirs("include", "src", "srclua5", "srclua5/lh")
        add_headerfiles("include/iuplua*.h")
        add_files(
            "srclua5/iuplua.c",
            "srclua5/iuplua_api.c",
            "srclua5/iuplua_draw.c",
            "srclua5/iuplua_tree_aux.c",
            "srclua5/iuplua_scanf.c",
            "srclua5/iuplua_getparam.c",
            "srclua5/iuplua_getcolor.c",
            "srclua5/iuplua_config.c",
            "srclua5/elem/il_*.c"
        )
        if is_plat("linux", "macosx", "bsd") then
            add_syslinks("m")
            add_shflags("$(shell pkg-config --libs gtk+-3.0 cairo pangocairo fontconfig freetype2)", {force = true})
        end

    target("iupluacd")
        set_kind("shared")
        set_prefixname("")
        if not is_plat("windows") then
            add_cxflags("-fPIC")
        end
        add_deps("iuplua", {inherit = false})
        add_deps("iup", "iupcd")
        add_packages("cd", "lua")
        add_defines("CD_NO_OLD_INTERFACE")
        add_includedirs("include", "src", "srclua5")
        add_files("srclua5/iuplua_cd.c")
        if is_plat("linux", "macosx", "bsd") then
            add_syslinks("m")
            add_shflags("-Wl,-rpath,$ORIGIN")
        end
        on_load(function (target)
            target:add("linkdirs", target:targetdir())
            local cd = target:pkg("cd")
            if cd then
                local cd_lib = path.join(cd:installdir(), "lib")
                target:add("linkdirs", cd_lib)
                target:add("rpathdirs", cd_lib)
                if is_plat("windows") then
                    target:add("links", "iuplua", "cdlua")
                else
                    target:add("shflags", "-l:iuplua.so", {force = true})
                    target:add("shflags", "-l:cdlua.so", {force = true})
                end
            end
        end)

    target("iupluaim")
        set_kind("shared")
        set_prefixname("")
        if not is_plat("windows") then
            add_cxflags("-fPIC")
        end
        add_deps("iuplua", {inherit = false})
        add_deps("iup", "iupim")
        add_packages("im", "lua")
        add_includedirs("include", "src", "srclua5")
        add_files("srclua5/iuplua_im.c")
        if is_plat("linux", "macosx", "bsd") then
            add_syslinks("m")
            add_shflags("-Wl,-rpath,$ORIGIN")
        end
        on_load(function (target)
            target:add("linkdirs", target:targetdir())
            local im = target:pkg("im")
            if im then
                local im_lib = path.join(im:installdir(), "lib")
                target:add("linkdirs", im_lib)
                target:add("rpathdirs", im_lib)
                if is_plat("windows") then
                    target:add("links", "iuplua", "imlua")
                else
                    target:add("shflags", "-l:iuplua.so", {force = true})
                    target:add("shflags", "-l:imlua.so", {force = true})
                end
            end
        end)

    target("iupluacontrols")
        set_kind("shared")
        set_prefixname("")
        if not is_plat("windows") then
            add_cxflags("-fPIC")
        end
        add_deps("iuplua", {inherit = false})
        add_deps("iup", "iupcontrols", "iupcd")
        add_packages("cd", "lua")
        add_defines("IUPLUA_USELH")
        add_includedirs("include", "src", "srclua5", "srclua5/lh", "srclua5/ctrl")
        add_files(
            "srclua5/ctrl/iuplua_controls.c",
            "srclua5/ctrl/iuplua_matrix_aux.c",
            "srclua5/ctrl/il_matrix.c",
            "srclua5/ctrl/il_matrixlist.c",
            "srclua5/ctrl/il_matrixex.c",
            "srclua5/ctrl/il_cells.c"
        )
        if is_plat("linux", "macosx", "bsd") then
            add_syslinks("m")
            add_shflags("-Wl,-rpath,$ORIGIN")
        end
        on_load(function (target)
            target:add("linkdirs", target:targetdir())
            local cd = target:pkg("cd")
            if cd then
                local cd_lib = path.join(cd:installdir(), "lib")
                target:add("linkdirs", cd_lib)
                target:add("rpathdirs", cd_lib)
                if is_plat("windows") then
                    target:add("links", "iuplua", "cdlua")
                else
                    target:add("shflags", "-l:iuplua.so", {force = true})
                    target:add("shflags", "-l:cdlua.so", {force = true})
                end
            end
        end)

    target("iupluaimglib")
        set_kind("shared")
        set_prefixname("")
        if not is_plat("windows") then
            add_cxflags("-fPIC")
        end
        add_deps("iuplua", {inherit = false})
        add_deps("iup", "iupimglib")
        add_packages("lua")
        add_includedirs("include", "src", "srclua5")
        add_files("srclua5/iuplua_imglib.c")
        if is_plat("linux", "macosx", "bsd") then
            add_syslinks("m")
            add_shflags("-Wl,-rpath,$ORIGIN")
        end
        on_load(function (target)
            target:add("linkdirs", target:targetdir())
            if is_plat("windows") then
                target:add("links", "iuplua")
            else
                target:add("shflags", "-l:iuplua.so", {force = true})
            end
        end)
end
