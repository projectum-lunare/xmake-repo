-- Projectum Lunare Xmake Repository - lua-resty-openidc Package
-- Category: OpenResty & NGINX Ecosystem
-- OpenID Connect Relying Party and OAuth 2.0 Resource Server for OpenResty
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("lua-resty-openidc")
    set_homepage("https://github.com/zmartzone/lua-resty-openidc")
    set_description("OpenID Connect Relying Party and OAuth 2.0 Resource Server for OpenResty.")
    set_license("Apache-2.0")

    add_urls("https://github.com/zmartzone/lua-resty-openidc/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/zmartzone/lua-resty-openidc.git")

    add_versions("v1.9.3", "d022bad4e339a83ebccf5d0e4c4710aaf85b31564e425a32da36aac7e073b7b3")
    add_versions("v1.9.2", "96e0601ee6ac8df9b7c2150e7e70da7c257eae6a8fc4deb58d2cc44489f3b4d7")
    add_versions("v1.9.1", "4cc7b5e3e49fbf7af0dccdc9bc850afacf9b7f6b93e7a49dd6e2a4750f8317d5")

    add_deps("lua")
    add_deps("lua-cjson", {configs = {shared = true}})
    add_deps("lua-resty-http")
    add_deps("lua-resty-string")
    add_deps("lua-resty-session")
    add_deps("lua-resty-jwt")
    add_deps("recudo master", {kind = "addon"})

    on_install(function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            includes("@addon/recudo/recudo.lua")

            target("lua-resty-openidc")
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
                config = {
                    subsystem = "http",
                    ngx_lua_version = 10028,
                },
                encode_base64 = function(s) return s end,
                decode_base64 = function(s) return s end,
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
            package.preload["ngx.base64"] = function()
                return {
                    encode_base64url = function(s) return s end,
                    decode_base64url = function(s) return s end
                }
            end
            package.preload["string.buffer"] = function()
                return {
                    new = function()
                        return {
                            put = function() end,
                            get = function() return "" end,
                            set = function() end,
                            reset = function() end
                        }
                    end
                }
            end
            package.preload["bit"] = function()
                return {
                    band = function(a, b) return a & b end,
                    bxor = function(a, b) return a ~ b end,
                    bor = function(a, b) return a | b end,
                    bnot = function(a) return ~a end,
                    lshift = function(a, b) return a << b end,
                    rshift = function(a, b) return a >> b end,
                    tohex = function(n) return string.format("%x", n) end
                }
            end
            package.preload["resty.openssl.rand"] = function()
                return {
                    bytes = function(len)
                        return string.rep("x", len or 32)
                    end
                }
            end
            package.preload["resty.openssl.digest"] = function()
                return {
                    new = function(algo)
                        return {
                            final = function(self, val)
                                return string.rep("h", 32)
                            end,
                            reset = function(self)
                                return true
                            end
                        }
                    end
                }
            end
            local openidc = require("resty.openidc")
            assert(openidc.authenticate or openidc.access_token)
        ]])
    end)
