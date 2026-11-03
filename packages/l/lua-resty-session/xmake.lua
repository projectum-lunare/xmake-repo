-- Projectum Lunare Xmake Repository - lua-resty-session Package
-- Category: OpenResty & NGINX Ecosystem
-- Session library for OpenResty - Flexible and secure sessions
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("lua-resty-session")
    set_homepage("https://github.com/bungle/lua-resty-session")
    set_description("Session library for OpenResty - Flexible and secure sessions.")
    set_license("BSD-2-Clause")

    add_urls("https://github.com/bungle/lua-resty-session/archive/refs/tags/v$(version).tar.gz")
    add_urls("https://github.com/bungle/lua-resty-session.git")

    add_versions("4.2.0", "4cda4eb3885175657fa3124db7b8e7020d78975e0db403d1135c5a2a736cad47")
    add_versions("4.1.5", "83e8b027032fd31947e08ad00c9406bd9af8f01ec0ba1901373ddb37bfcc04ab")
    add_versions("4.1.4", "3c7b7cf78d1d265bedcaf54f3ea52335156f30e22bff0a6a0fd07c6230520372")


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

            target("lua-resty-session")
                add_rules("recudo.lua.module")
                add_packages("lua")
                add_files("lib/**.lua")
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
                config = {
                    subsystem = "http",
                    ngx_lua_version = 10028,
                }
            }, mt)
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
            local session = require("resty.session")
            assert(session.init or session.new or session.open)
        ]])
    end)
