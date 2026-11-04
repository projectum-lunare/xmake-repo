-- Projectum Lunare Xmake Repository - lua-http Package
-- Category: Networking, Web & Services (HTTP Clients & Servers)
-- Modern HTTP/1.1 and HTTP/2 client/server and WebSocket library for Lua
-- Supported Platforms: Linux, macOS, BSD, Haiku

package("lua-http")
    set_homepage("https://github.com/daurnimator/lua-http")
    set_description("Performant, modern HTTP/1.1 and HTTP/2 client/server and WebSocket library for Lua.")
    set_license("MIT")

    add_urls("https://github.com/daurnimator/lua-http/archive/refs/tags/v$(version).tar.gz")
    add_urls("https://github.com/daurnimator/lua-http.git")

    add_versions("0.4", "d2e3cb9bc04cab70ac4f19351bc74b0dcd8b16cfc2563aa77256eb3a43b3b9e0")

    add_configs("zlib", {description = "Enable gzip compression via lua-zlib", default = true, type = "boolean"})
    add_configs("psl", {description = "Enable Public Suffix List support via lua-psl", default = true, type = "boolean"})

    on_load(function (package)
        import("@addon.recudo.lua.runtime").setup(package, {
            runtime = {"lua", "luajit"},
            default = "lua",
            version = ">=5.1 <=5.4",
        })
        package:add("deps", "cqueues", {configs = {shared = true}})
        package:add("deps", "luaossl", {configs = {shared = true}})
        package:add("deps", "basexx")
        package:add("deps", "binaryheap")
        package:add("deps", "fifo.lua")
        package:add("deps", "lpeg-patterns")

        if package:config("zlib") then
            package:add("deps", "lua-zlib", {configs = {shared = true}})
        end

        if package:config("psl") then
            package:add("deps", "lua-psl", {configs = {shared = true}})
        end

        local rt = package:config("runtime") or "lua"
        if rt == "luajit" or rt == "openresty-luajit" then
            package:add("deps", "lua-compat-5.3")
        elseif rt == "lua" then
            local lua_ver = package:config("lua_version")
            if lua_ver and lua_ver:find("^5%.1") then
                package:add("deps", "lua-compat-5.3")
                package:add("deps", "bit32")
            elseif lua_ver and lua_ver:find("^5%.2") then
                package:add("deps", "lua-compat-5.3")
            end
        end
    end)

    on_install(function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            includes("@addon/recudo/recudo.lua")

            target("http")
                add_rules("recudo.lua.module")
                add_packages("lua")
                add_files("http/**.lua")
        ]])
        import("@addon.recudo.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.recudo.lua.module").lua_test(package, [[
            local http_version = require("http.version")
            assert(http_version)
            local headers = require("http.headers")
            local h = headers.new()
            h:append(":method", "GET")
            assert(h:get(":method") == "GET")
            local cookie = require("http.cookie")
            assert(cookie)
            local zlib = require("http.zlib")
            assert(zlib and zlib.deflate)
            local req = require("http.request")
            assert(req)
        ]])
    end)
