-- Projectum Lunare Xmake Repository - lua-mimetypes Package
-- Category: Networking, Web & Services
-- A simple library for looking up the MIME types of files
-- Supported Platforms: All platforms supporting Lua (POSIX, Windows, Vintage, Embedded)

package("lua-mimetypes")
    set_homepage("https://github.com/lunarmodules/lua-mimetypes")
    set_description("A simple library for looking up the MIME types of files.")
    set_license("MIT")

    add_urls("https://github.com/lunarmodules/lua-mimetypes/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/lunarmodules/lua-mimetypes.git")

    add_versions("v1.1.0", "0f035ae4cde86ad4187fa6e92d360659299911e3756947ba89f087c52d57cf0a")
    add_versions("v1.0.0", "f387475765ff3bcc7abf0f8ad67654bbb8d745569a70623b478f11bebfa585e5")

    add_deps("lua")
    add_deps("forge master", {kind = "addon"})
    set_kind("library", {headeronly = true})

    on_install(function (package)
        io.writefile("xmake.lua", [[
            target("mimetypes")
                add_rules("forge.lua.module")
                add_files("mimetypes.lua")
                add_files("mimetypes/**.lua")
        ]])
        import("@addon.forge.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.forge.lua.module").lua_test(package, [[
            local mimetypes = require("mimetypes")
            assert(mimetypes.guess("init.lua") == "text/x-lua")
            assert(mimetypes.guess("image.png") == "image/png")
        ]])
    end)
