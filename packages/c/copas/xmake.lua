-- Projectum Lunare Xmake Repository - copas Package
-- Category: Networking, Web & Services
-- Coroutine Oriented Portable Asynchronous Services for Lua
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("copas")
    set_homepage("https://github.com/lunarmodules/copas")
    set_description("Coroutine Oriented Portable Asynchronous Services for Lua.")
    set_license("MIT")

    add_urls("https://github.com/lunarmodules/copas/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/lunarmodules/copas.git")

    add_versions("4.12.0", "e5bf9668c6f9b6f24f15075488fdaa03c46df675c7a70412bf6fb974268a8174")
    add_versions("4.11.0", "4676141569f2a18ef835a579580c42a4b9a6a0b804f0eb89b2188bd64a4a9c47")

    add_deps("lua")
    if is_plat("windows", "mingw", "linux", "macosx", "bsd", "haiku") then
        add_deps("luasocket", {configs = {shared = true}})
    else
        add_deps("luasocket")
    end
    add_deps("coxpcall")
    add_deps("binaryheap")
    add_deps("timerwheel")
    add_deps("recudo master", {kind = "addon"})

    add_bindirs("bin")

    on_install(function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            includes("@addon/recudo/recudo.lua")

            target("copas")
                add_rules("recudo.lua.module")
                add_packages("lua")
                add_files("src/copas.lua")

            target("copas.ftp")
                add_rules("recudo.lua.module")
                add_packages("lua")
                add_files("src/copas/ftp.lua")

            target("copas.future")
                add_rules("recudo.lua.module")
                add_packages("lua")
                add_files("src/copas/future.lua")

            target("copas.http")
                add_rules("recudo.lua.module")
                add_packages("lua")
                add_files("src/copas/http.lua")

            target("copas.lock")
                add_rules("recudo.lua.module")
                add_packages("lua")
                add_files("src/copas/lock.lua")

            target("copas.queue")
                add_rules("recudo.lua.module")
                add_packages("lua")
                add_files("src/copas/queue.lua")

            target("copas.semaphore")
                add_rules("recudo.lua.module")
                add_packages("lua")
                add_files("src/copas/semaphore.lua")

            target("copas.smtp")
                add_rules("recudo.lua.module")
                add_packages("lua")
                add_files("src/copas/smtp.lua")

            target("copas.timer")
                add_rules("recudo.lua.module")
                add_packages("lua")
                add_files("src/copas/timer.lua")

            target("copas-bin")
                add_rules("recudo.lua.bin")
                add_files("bin/copas.lua")
        ]])
        import("@addon.recudo.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.recudo.lua.module").lua_test(package, [[
            local copas = require("copas")
            assert(copas and copas._VERSION)
            assert(require("copas.timer"))
            assert(require("copas.http"))
        ]])
    end)
