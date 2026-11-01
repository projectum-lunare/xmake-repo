add_rules("mode.release", "mode.debug")

option("lua")
    set_default(true)
    set_showmenu(true)
    set_description("Build Lua bindings (imlua and imlua_process)")
option_end()

if has_config("lua") then
    add_requires("lua")
end

target("im")
    set_kind("$(kind)")
    if not is_plat("windows") then
        add_cxflags("-fPIC")
    end
    add_includedirs("include", "src", "src/liblzf", "src/lz4", "src/libtiff", "src/libjpeg", "src/libpng", "src/libexif")
    add_headerfiles("include/(im*.h)")

    add_files("src/*.cpp|im_sysfile_*.cpp|im_dib*.cpp|im_capture_*.cpp|im_format_avi.cpp|im_format_wmv.cpp|im_format_jp2.cpp|im_format_ecw.cpp")
    add_files("src/im_oldcolor.c", "src/im_oldresize.c")

    if is_plat("windows") then
        add_files("src/im_sysfile_win32.cpp", "src/im_dib.cpp", "src/im_dibxbitmap.cpp")
    else
        add_files("src/im_sysfile_unix.cpp")
        add_syslinks("m", "z")
    end

    add_files("src/liblzf/*.c")
    add_files("src/lz4/*.c")
    add_files("src/libjpeg/*.c")
    add_files("src/libpng/*.c")
    add_files("src/libtiff/*.c|tif_win32.c|tif_unix.c|tif_webp.c|tif_zstd.c", "src/tiff_binfile.c")
    add_files("src/libexif/**.c")
    add_defines("USE_EXIF")

target("im_process")
    set_kind("$(kind)")
    if not is_plat("windows") then
        add_cxflags("-fPIC")
    end
    add_includedirs("include", "src")
    add_headerfiles("include/(im_process*.h)")
    add_deps("im")
    add_defines("IM_PROCESS")
    add_files("src/process/*.cpp|im_fft.cpp")
    add_files("src/im_convertbitmap.cpp", "src/im_convertcolor.cpp", "src/im_converttype.cpp")
    if not is_plat("windows") then
        add_syslinks("m")
    end

if has_config("lua") then
    target("imlua")
        set_kind("shared")
        if not is_plat("windows") then
            add_cxflags("-fPIC")
        end
        add_includedirs("include", "src", "src/lua5", "src/lua5/lh")
        add_headerfiles("include/imlua.h")
        add_defines("IMLUA_USELH")
        add_packages("lua")
        add_files("src/lua5/*.c|imlua_process.c|imlua_kernel.c|imlua_avi.c|imlua_wmv.c|imlua_capture.c|imlua_fftw.c|imlua_jp2.c")
        add_deps("im")
        set_prefixname("")
        if is_plat("windows") then
            set_extension(".dll")
        else
            set_extension(".so")
        end

    target("imlua_process")
        set_kind("shared")
        if not is_plat("windows") then
            add_cxflags("-fPIC")
        end
        add_includedirs("include", "src", "src/lua5", "src/lua5/lh")
        add_defines("IM_PROCESS", "IMLUA_USELH")
        add_packages("lua")
        add_files("src/lua5/imlua_process.c",
                  "src/lua5/imlua_kernel.c",
                  "src/lua5/imlua_convert.c",
                  "src/lua5/imlua_aux.c",
                  "src/lua5/imlua_file.c",
                  "src/lua5/imlua_image.c",
                  "src/lua5/imlua_palette.c",
                  "src/lua5/imlua_util.c")
        add_deps("im", "im_process")
        set_prefixname("")
        if is_plat("windows") then
            set_extension(".dll")
        else
            set_extension(".so")
        end
end
