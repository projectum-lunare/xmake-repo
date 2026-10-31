-- Projectum Lunare Xmake Repository - luvit Package
-- Asynchronous I/O for Lua (Node.js for Lua)
-- Supported Platforms: Linux, macOS, Windows

package("luvit")
    set_kind("binary")
    set_homepage("https://github.com/luvit/luvit")
    set_description("Asynchronous I/O for Lua - Node.js style APIs for luvi as either a luvi app or library.")
    set_license("Apache-2.0")

    add_urls("https://github.com/luvit/luvit/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/luvit/luvit.git")

    add_versions("2.9.1", "fcccc537f78b14a4eb8c30d985ae642b5906ae7e0582f0b1203d81b60deb0d41")
    add_versions("2.8.0", "83f43cd409bac1891d6690b0bc8a359a72670f59740f59a3157a2fce25252e21")
    add_versions("2.7.4", "506d75889a1f44db983ba63b93c3cd5d0616a7ece7c2546221d018513c60bd26")

    add_deps("lit")

    add_bindirs("bin")

    on_install(function (package)
        local lit_dep = package:dep("lit")
        local lit_bin = path.join(lit_dep:installdir("bin"), package:is_plat("windows") and "lit.exe" or "lit")
        local luvi_bin = path.join(lit_dep:installdir("bin"), package:is_plat("windows") and "luvi.exe" or "luvi")

        local luvit_bin = path.join(package:installdir("bin"), package:is_plat("windows") and "luvit.exe" or "luvit")
        os.mkdir(package:installdir("bin"))

        os.vrunv(lit_bin, {"make", ".", luvit_bin, luvi_bin})
        if not package:is_plat("windows") then
            os.vrunv("chmod", {"+x", luvit_bin})
        end
    end)

    on_test(function (package)
        os.vrun("luvit -v")
        os.vrunv("luvit", {"-e", "print('Hello from Luvit!')"})
    end)
