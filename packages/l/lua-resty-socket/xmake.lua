-- Projectum Lunare Xmake Repository - lua-resty-socket Package
-- Category: OpenResty & NGINX Ecosystem
-- Automatic LuaSocket/ngx.socket.tcp fallback with identical API
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("lua-resty-socket")
    set_homepage("https://github.com/thibaultcha/lua-resty-socket")
    set_description("Automatic LuaSocket/ngx.socket.tcp fallback with identical API.")
    set_license("MIT")

    add_urls("https://github.com/thibaultcha/lua-resty-socket/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/thibaultcha/lua-resty-socket.git")

    add_versions("1.0.0", "21ab78c3c639118523a691ec4f941fab391c83b59017cfa8203bdd5ae792675b")
    add_versions("0.0.6", "e1ece30c98154452a7ed57ed1e65228c51db6b259b0bb0fc76c2af330311a21b")
    add_versions("0.0.5", "0512acebd5dc388311fd9716fd969b8aefc31319b0756aef6bcc80b92e8e228b")

    add_deps("lua")
    add_deps("recudo master", {kind = "addon"})

    on_install(function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            includes("@addon/recudo/recudo.lua")

            target("lua-resty-socket")
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
            _G.ngx = setmetatable({
                socket = {
                    tcp = function() return {} end
                }
            }, mt)
            local socket = require("resty.socket")
            assert(socket.tcp)
        ]])
    end)
