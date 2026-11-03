-- Projectum Lunare Xmake Repository - lua-resty-signal Package
-- Category: OpenResty & NGINX Ecosystem
-- POSIX signal library for OpenResty
-- Supported Platforms: Linux, macOS, BSD

package("lua-resty-signal")
    set_homepage("https://github.com/openresty/lua-resty-signal")
    set_description("POSIX signal library for OpenResty.")
    set_license("BSD-2-Clause")

    add_urls("https://github.com/openresty/lua-resty-signal/archive/refs/tags/v$(version).tar.gz")
    add_urls("https://github.com/openresty/lua-resty-signal.git")

    add_versions("0.05", "3310322cdca14a92e01f30570fdeb6c16c001af270957b9e275dae0e4e7d5190")
    add_versions("0.04", "1347a39d4426cdedff8141c3cdcb65a3ac53b9326b08a8793d9a0a3116966825")
    add_versions("0.03", "f0bf3e4645dc7a658951febc9f3a62e948beec870082fe7403616dbeb2202c5b")

    add_deps("lua")
    add_deps("lua-resty-core")
    add_deps("recudo master", {kind = "addon"})

    on_install("linux", "macosx", "bsd", function (package)
        io.gsub("lib/resty/signal.lua", 'for k, _ in string_gmatch%(cpath, "%[%^;%]%+"%) do%s+if k == "%?%.so" then%s+k = "%./"%s+end%s+local fpath = string_match%(k, "%(%.%*/%)"%)', [[for k, _ in string_gmatch(cpath, "[^;]+") do
            local dir = k == "?.so" and "./" or k
            local fpath = string_match(dir, "(.*/)") ]])

        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            includes("@addon/recudo/recudo.lua")

            target("restysignal")
                set_kind("shared")
                set_basename("restysignal")
                set_prefixname("lib")
                set_extension(".so")
                add_files("resty_signal.c")

            target("lua-resty-signal")
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
                config = {
                    subsystem = "http",
                    ngx_lua_version = 10028,
                }
            }, mt)
            _G.jit = { version = "LuaJIT 2.1.0", version_num = 20100 }
            _G.getfenv = _G.getfenv or function() return _G end
            package.preload["ffi"] = function()
                return {
                    new = function() return nil end,
                    string = function() return "" end,
                    typeof = function() return nil end,
                    sizeof = function() return 8 end,
                    cdef = function() end,
                    errno = function() return 0 end,
                    load = function(path)
                        return {
                            resty_signal_signum = function(id) return id end
                        }
                    end,
                    C = {
                        kill = function() return 0 end,
                        strerror = function() return "" end
                    }
                }
            end
            local signal = require("resty.signal")
            assert(signal.signum)
            assert(signal.kill)
        ]])
    end)
