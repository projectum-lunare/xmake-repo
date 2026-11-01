-- Projectum Lunare Xmake Repository - magick Package
-- Category: System, Hardware & Native Bindings
-- Lua bindings to ImageMagick & GraphicsMagick for LuaJIT using FFI
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("magick")
    set_homepage("https://github.com/leafo/magick")
    set_description("Lua bindings to ImageMagick & GraphicsMagick for LuaJIT using FFI.")
    set_license("MIT")

    add_urls("https://github.com/leafo/magick/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/leafo/magick.git")

    add_versions("v1.6.0", "fe5c86590e42955a113edd0b202a0f0845d80666f8d763955a043e9d3ccdb964")
    add_versions("v1.5.0", "66dd8066132fd5c16f0da9ccd07f200378b0130df1c281fa9a75854c7d4ba7f1")

    on_load(function (package)
        import("@addon.forge.lua.runtime").setup(package, {
            runtime = "luajit",
        })
    end)

    on_install(function (package)
        io.writefile("xmake.lua", [[
            target("magick")
                add_rules("forge.lua.module")
                set_values("forge.lua.rootdir", os.projectdir())
                add_files("magick/**.lua")
        ]])
        import("@addon.forge.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.forge.lua.module").lua_test(package, "local version = require('magick.version'); assert(type(version) == 'string')")
    end)
