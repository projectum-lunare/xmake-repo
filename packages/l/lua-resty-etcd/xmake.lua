-- Projectum Lunare Xmake Repository - lua-resty-etcd Package
-- Category: OpenResty & NGINX Ecosystem
-- Nonblocking Lua etcd driver library for OpenResty
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("lua-resty-etcd")
    set_homepage("https://github.com/api7/lua-resty-etcd")
    set_description("Nonblocking Lua etcd driver library for OpenResty.")
    set_license("Apache-2.0")

    add_urls("https://github.com/api7/lua-resty-etcd/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/api7/lua-resty-etcd.git")

    add_versions("v1.9.0", "1fb3b89845b37160872ef543041b10d7f829452eda3e7031b3fb34b5c17f043c")
    add_versions("v1.8.3", "511ad83647ae4267c36d18ef8a0ad05dcf512cfb9b2bcd36558e8a548cabdaf0")
    add_versions("v1.8.2", "e85e580b31d5e6e8f49d030fbe68e2efa7b533b7e9e3a3911eba3a820b7fd3bc")

    add_deps("lua-typeof")
    add_deps("lua-resty-http")
    add_deps("lua-resty-string")
    add_deps("penlight")
    add_deps("lua-cjson", {configs = {shared = true}})

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

            target("lua-resty-etcd")
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
            mt.__call = function(t, ...)
                return nil
            end
            _G.ngx = setmetatable({
                log = function(...) end,
                now = function() return 1000 end,
                worker = {
                    pid = function() return 1234 end
                },
                encode_args = function() return "" end,
                encode_base64 = function(s) return s end,
                decode_base64 = function(s) return s end,
                config = {
                    subsystem = "http",
                    ngx_lua_version = 10028,
                }
            }, mt)
            package.preload["ffi"] = function()
                return {
                    new = function() return nil end,
                    string = function() return "" end,
                    typeof = function() return nil end,
                    sizeof = function() return 8 end,
                    cdef = function() end,
                    errno = function() return 0 end,
                    C = {}
                }
            end
            package.preload["table.clear"] = function()
                return function(t) for k in pairs(t) do t[k] = nil end end
            end
            package.preload["table.nkeys"] = function()
                return function(t)
                    local n = 0
                    for _ in pairs(t) do n = n + 1 end
                    return n
                end
            end
            package.preload["table.clone"] = function()
                return function(t)
                    local copy = {}
                    for k, v in pairs(t) do copy[k] = v end
                    return copy
                end
            end
            package.preload["ngx.semaphore"] = function()
                return {
                    new = function()
                        return {
                            wait = function() return true end,
                            post = function() return true end,
                        }
                    end
                }
            end
            package.preload["ngx.re"] = function()
                return {
                    split = function(s, sep) return {s} end
                }
            end
            local http = require("resty.http")
            http.tls_handshake = http.tls_handshake or function(...) return true end
            local etcd = require("resty.etcd")
            assert(etcd.new)
        ]])
    end)
