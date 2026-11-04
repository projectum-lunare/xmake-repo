-- Projectum Lunare Xmake Repository - luv Package
-- Category: Networking, Web & Services
-- Bare libuv bindings for Lua
-- Supported Platforms: Linux, macOS, Windows, BSD, Haiku, WASM

package("luv")
    set_homepage("https://github.com/luvit/luv")
    set_description("Bare libuv bindings for Lua.")
    set_license("Apache-2.0")

    add_urls("https://github.com/luvit/luv/releases/download/$(version)/luv-$(version).tar.gz")
    add_urls("https://github.com/luvit/luv.git")

    add_versions("1.53.0-0", "fccabc7bb37fcc3b84ab258a19a862c55f67abc2059af0a744a1ae64119dfc6c")
    add_versions("1.52.1-0", "3e6eb820a3aee034f85f9cce9bd77b5d42f34d128a1ccec877adf28c913577c7")
    add_versions("1.51.0-0", "eb121ca0a26a417330eacf590f87ab30c426ab287e38a79a779e7e8708dc9aa3")

    add_deps("libuv")

    on_load(function (package)
        import("@addon.recudo.lua.runtime").setup(package, {
            runtime = {"lua", "luajit"},
        })
    end)

    on_install(function (package)
        io.writefile("xmake.lua", string.format([[
            add_requires("libuv")

            target("luv")
                add_rules("recudo.lua.module")
                add_packages("libuv")
                add_includedirs("src", "deps/lua-compat-5.3/c-api")
                add_defines("LUV_VERSION=\"%s\"")
                add_files("src/luv.c")
        ]], package:version_str()))
        import("@addon.recudo.lua.module").install_project(package)
    end)

    on_test(function (package)
        if package:is_plat("linux", "macosx", "bsd") and not package:config("shared") then
            return
        end
        import("@addon.recudo.lua.module").lua_test(package, [[
            local uv = require("luv")
            assert(uv and type(uv.version) == "function")
            assert(uv.version() > 0)
        ]])
    end)
