-- Projectum Lunare Xmake Repository - lit Package
-- Category: Runtimes & Core Language
-- The Luvit Invention Toolkit (lit) is a package manager and build tool for luvi apps
-- Supported Platforms: Linux, macOS, Windows

package("lit")
    set_kind("binary")
    set_homepage("https://github.com/luvit/lit")
    set_description("The Luvit Invention Toolkit is a luvi app that handles dependencies and luvi builds.")
    set_license("Apache-2.0")

    add_urls("https://github.com/luvit/lit/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/luvit/lit.git")

    add_versions("3.8.5", "1940ca56474d5eebd15a2b2aecd961675f1e5b074ae506aeba03f4c4374101cf")
    add_versions("3.8.4", "28521ae4d6abdc58236d25a14d44b4385218108c2ef247787f9ac837b31064a9")
    add_versions("3.8.3", "77feee04c5e6f55021d016b2902fd235da9c65c747c3bbcb6c824135772c04c6")

    add_bindirs("bin")

    on_install(function (package)
        import("net.http")
        local luvi_name
        if package:is_plat("windows") then
            luvi_name = package:is_arch("x64", "x86_64") and "luvi-regular-Windows-amd64.exe" or "luvi-regular-Windows-ia32.exe"
        elseif package:is_plat("macosx") then
            luvi_name = "luvi-regular-Darwin_x86_64"
        else
            luvi_name = "luvi-regular-Linux_" .. (package:is_arch("x64", "x86_64") and "x86_64" or "i686")
        end
        local luvi_url = "https://github.com/luvit/luvi/releases/download/v2.14.0/" .. luvi_name
        local luvi_bin = path.join(os.curdir(), package:is_plat("windows") and "luvi.exe" or "luvi")
        http.download(luvi_url, luvi_bin)
        if not package:is_plat("windows") then
            os.vrunv("chmod", {"+x", luvi_bin})
        end

        local lit_zip = path.join(os.curdir(), "lit.zip")
        http.download("https://lit.luvit.io/packages/luvit/lit/v" .. package:version():shortstr() .. ".zip", lit_zip)

        local lit_bin = path.join(package:installdir("bin"), package:is_plat("windows") and "lit.exe" or "lit")
        local luvi_dst = path.join(package:installdir("bin"), package:is_plat("windows") and "luvi.exe" or "luvi")
        os.mkdir(package:installdir("bin"))
        os.cp(luvi_bin, luvi_dst)
        os.vrunv(luvi_bin, {lit_zip, "--", "make", lit_zip, lit_bin, luvi_bin})
        if not package:is_plat("windows") then
            os.vrunv("chmod", {"+x", lit_bin})
            os.vrunv("chmod", {"+x", luvi_dst})
        end
    end)

    on_test(function (package)
        os.vrun("lit --version")
    end)
