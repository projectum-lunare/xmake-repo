-- Projectum Lunare Xmake Repository - IM Package
-- Category: System, Hardware & Native Bindings
-- Image Representation, Storage, Capture and Processing Toolkit (Tecgraf/PUC-Rio)
-- Supported Platforms: Linux, macOS, Windows

package("im")
    set_homepage("https://www.tecgraf.puc-rio.br/im/")
    set_description("An Image Representation, Storage, Capture and Processing Toolkit (Tecgraf/PUC-Rio).")
    set_license("MIT")

    add_urls("https://downloads.sourceforge.net/project/imtoolkit/$(version)/Docs%20and%20Sources/im-$(version)_Sources.tar.gz")
    add_versions("3.15", "36cc4257f8f5f81128b854bb3be29c5cbdd091476528f315af666d0930b9b57e")

    add_patches("3.15", path.join(os.scriptdir(), "patches", "3.15", "imlua.patch"), "65e1aeebaa1c1710ef89bf1d7a071f818b3285ca19470a87961a4d56e094e2dd")

    add_configs("lua", {description = "Build Lua bindings (imlua and imlua_process)", default = true, type = "boolean"})

    add_includedirs("include", "include/im")
    add_links("im_process", "im")

    if is_plat("linux", "macosx", "bsd") then
        add_syslinks("m", "z")
    elseif is_plat("windows") then
        add_syslinks("user32", "gdi32")
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
            local ext = package:is_plat("windows") and "dll" or "so"
            local mod_dir = package:installdir("lib/lua/5.4")
            os.mkdir(mod_dir)
            local imlua_mod = package:installdir("lib", "imlua." .. ext)
            local imlua_proc_mod = package:installdir("lib", "imlua_process." .. ext)
            if os.isfile(imlua_mod) then
                os.cp(imlua_mod, mod_dir)
            end
            if os.isfile(imlua_proc_mod) then
                os.cp(imlua_proc_mod, mod_dir)
            end
            package:addenv("LUA_CPATH", package:installdir("lib/lua/5.4/?." .. ext))
            package:addenv("LUA_CPATH", package:installdir("lib/?." .. ext))
        end
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            #include <im.h>
            #include <im_lib.h>
            #include <im_image.h>
            #include <im_process.h>
            void test() {
                const char* ver = imVersion();
                imImage* img = imImageCreate(10, 10, IM_RGB, IM_BYTE);
                if (img) imImageDestroy(img);
            }
        ]]}))

        if package:config("lua") then
            import("@addon.forge.lua.module").lua_test(package, [[
                local im = require("imlua")
                local proc = require("imlua_process")
                assert(im.VersionNumber() > 0)
                local img = im.ImageCreate(50, 50, im.RGB, im.BYTE)
                assert(img:Width() == 50)
                local res, new_img = im.ProcessResizeNew(img, 100, 100, 1)
                assert(res and new_img:Width() == 100)
            ]])
        end
    end)
