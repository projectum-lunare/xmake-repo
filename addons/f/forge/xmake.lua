-- Projectum Lunare Xmake Repository - forge
-- Category: Build System & Toolchains (Addons)

package("forge")
    set_kind("addon")
    set_homepage("https://github.com/projectum-lunare/forge")
    set_description("Projectum Lunare Unified Build, Toolchain & Cross-Compilation Addon")
    set_license("MPL-2.0")

    add_urls("https://github.com/projectum-lunare/forge.git")
    add_versions("master", "a483656d820c3dcff611ce8e0395b817d44e4133")
    add_versions("v0.1.1", "v0.1.1")
    add_versions("v0.1.0", "v0.1.0")

    on_test(function (package)
        assert(package:has_addon())
    end)
