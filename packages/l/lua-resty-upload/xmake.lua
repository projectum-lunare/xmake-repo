-- Projectum Lunare Xmake Repository - lua-resty-upload Package
-- Category: OpenResty & NGINX Ecosystem
-- Streaming reading and parsing for HTTP file uploading based on ngx_lua cosockets
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("lua-resty-upload")
    set_homepage("https://github.com/openresty/lua-resty-upload")
    set_description("Streaming reading and parsing for HTTP file uploading based on ngx_lua cosockets.")
    set_license("BSD-2-Clause")

    add_urls("https://github.com/openresty/lua-resty-upload/archive/refs/tags/v$(version).tar.gz")
    add_urls("https://github.com/openresty/lua-resty-upload.git")

    add_versions("0.11", "deb4ab1ffb9f3d962c4b4a2c4bdff692b86a209e3835ae71ebdf3b97189e40a9")
    add_versions("0.10", "5d16e623d17d4f42cc64ea9cfb69ca960d313e12f5d828f785dd227cc483fcbd")
    add_versions("0.09", "56ab35526b8f3e2d8f7872a8de332ea2fb8656c4bf3ca161fe964be1689d28ed")


    on_load(function (package)
        import("@addon.recudo.lua.runtime").setup(package, {
            runtime = {"luajit", "openresty-luajit"},
            default = "luajit",
        })
    end)


    on_install(function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            includes("@addon/recudo/recudo.lua")

            target("lua-resty-upload")
                add_rules("recudo.lua.module")
                add_packages("lua")
                add_files("lib/resty/**.lua")
        ]])
        import("@addon.recudo.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.recudo.lua.module").lua_test(package, [[
            local mt = {}
            mt.__index = function(t, k)
                t[k] = setmetatable({}, mt)
                return t[k]
            end
            _G.ngx = setmetatable({}, mt)
            local upload = require("resty.upload")
            assert(upload.new)
        ]])
    end)
