-- Projectum Lunare Xmake Repository - lua-resty-requests Package
-- Category: OpenResty & NGINX Ecosystem
-- Yet Another HTTP library for OpenResty - HTTP library for Humans
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("lua-resty-requests")
    set_homepage("https://github.com/tokers/lua-resty-requests")
    set_description("Yet Another HTTP library for OpenResty - HTTP library for Humans.")
    set_license("BSD-2-Clause")

    add_urls("https://github.com/tokers/lua-resty-requests/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/tokers/lua-resty-requests.git")

    add_versions("v0.7.3", "69fbe7cf3dbf08362674731610529b6b78831a24588f6b4e7ab280e9ae72b08f")
    add_versions("v0.7.2", "a1df91dfef28a975f2dccaab447c5fbfa92de01a386f3e89b5d7bb010d6c7b8d")
    add_versions("v0.7.1", "e3e7057e81271cb762bd99cc5079817368f0d5996c32471e15931284806a420c")

    add_deps("lua")
    add_deps("lua-cjson", {configs = {shared = true}})
    add_deps("lua-resty-socket")
    add_deps("lua-resty-http2")
    add_deps("recudo master", {kind = "addon"})

    on_install(function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            includes("@addon/recudo/recudo.lua")

            target("lua-resty-requests")
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
                log = function(...) end,
                config = {
                    subsystem = "http",
                    ngx_lua_version = 10028,
                    debug = false,
                },
                socket = {
                    tcp = function() return {} end
                }
            }, mt)
            local requests = require("resty.requests")
            assert(requests.get or requests.post or requests.request)
        ]])
    end)
