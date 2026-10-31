-- Projectum Lunare Xmake Repository - lua-resty-shell Package
-- Category: OpenResty & NGINX Ecosystem
-- Lua module for nonblocking system shell command executions in OpenResty
-- Supported Platforms: Linux, macOS, BSD

package("lua-resty-shell")
    set_homepage("https://github.com/openresty/lua-resty-shell")
    set_description("Lua module for nonblocking system shell command executions in OpenResty.")
    set_license("BSD-2-Clause")

    add_urls("https://github.com/openresty/lua-resty-shell/archive/refs/tags/v$(version).tar.gz")
    add_urls("https://github.com/openresty/lua-resty-shell.git")

    add_versions("0.03", "058b6ab0110076926a226c828921cc76395b98eb575a051ca9b99238aabbb222")
    add_versions("0.02", "a928b9074d3f61a64ca72172b10233a892b14fe20d20032283b281c80e1be74f")
    add_versions("0.01", "3c8a38c146a02fad4ae2b5b651f3164b31d8bffa6359c0a8d6c70789400c102c")

    add_deps("lua")
    add_deps("lua-resty-signal")
    add_deps("lua-tablepool")
    add_deps("forge master", {kind = "addon"})

    on_install("linux", "macosx", "bsd", function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            includes("@addon/forge/forge.lua")

            target("lua-resty-shell")
                add_rules("forge.lua.module")
                add_packages("lua")
                add_files("lib/resty/**.lua")
        ]])
        import("@addon.forge.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.forge.lua.module").lua_test(package, [[
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
            package.preload["ngx.pipe"] = function()
                return {
                    spawn = function() return nil end
                }
            end
            package.preload["table.new"] = function()
                return function(narr, nrec) return {} end
            end
            package.preload["table.clear"] = function()
                return function(t) for k in pairs(t) do t[k] = nil end end
            end
            local shell = require("resty.shell")
            assert(shell.run)
        ]])
    end)
