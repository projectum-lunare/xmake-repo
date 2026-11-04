-- Projectum Lunare Xmake Repository - cqueues Package
-- Category: Concurrency, Asynchronous & Coroutines
-- Continuation queues: embeddable, stackable coroutine event loop for Lua
-- Supported Platforms: Linux, macOS, BSD, Haiku

package("cqueues")
    set_homepage("https://github.com/wahern/cqueues")
    set_description("A stackable, coroutine-based event loop for Lua on POSIX systems.")
    set_license("MIT")

    add_urls("https://github.com/wahern/cqueues/archive/refs/tags/rel-$(version).tar.gz")
    add_urls("https://github.com/wahern/cqueues.git")

    add_versions("20200726", "9e112edd246da5cfca264314b70325a0b63665cb87a00e45ee3ae4f194000d52")

    add_deps("openssl")

    if is_plat("linux") then
        add_syslinks("pthread", "dl", "rt", "m")
    elseif is_plat("macosx", "bsd") then
        add_syslinks("pthread", "m")
    end

    on_load(function (package)
        import("@addon.recudo.lua.runtime").setup(package, {
            runtime = {"lua", "luajit"},
            default = "lua",
            version = ">=5.1 <=5.4",
        })
    end)

    on_install("linux", "macosx", "bsd", "haiku", function (package)
        local lua_pkg = package:dep("lua") or package:dep("luajit")
        local lua_inc = lua_pkg and lua_pkg:installdir("include") or ""

        local openssl = package:dep("openssl")
        local ssl_inc = openssl and openssl:installdir("include") or ""
        local ssl_lib = openssl and openssl:installdir("lib") or ""

        local cppflags = string.format("-I%s -I%s", lua_inc, ssl_inc)
        local ldflags = ssl_lib ~= "" and string.format("-L%s -Wl,-rpath,%s", ssl_lib, ssl_lib) or ""

        local inst_lib = package:installdir("lib/lua")
        local inst_share = package:installdir("share/lua")

        import("package.tools.make").build(package, {
            "all5.4",
            "LUA_APIS=5.4",
            "CPPFLAGS=-I" .. ssl_inc,
            "LUA54_CPPFLAGS=" .. cppflags,
            "LDFLAGS=" .. ldflags,
            "CC=" .. (package:build_getenv("cc") or "gcc"),
        })

        import("package.tools.make").make(package, {
            "install5.4",
            "DESTDIR=" .. package:installdir(),
            "prefix=",
            "lua54cpath=/lib/lua",
            "lua54path=/share/lua",
        })

        for _, f in ipairs(os.files(path.join(package:installdir(), "lib/lua/*.so"))) do
            os.cp(f, package:installdir("lib"))
        end
    end)

    on_test(function (package)
        if package:config("shared") then
            import("@addon.recudo.lua.module").lua_test(package, [[
                local cq = require("cqueues")
                assert(cq and cq.VERSION)
                local q = cq.new()
                assert(q)
            ]])
        end
    end)
