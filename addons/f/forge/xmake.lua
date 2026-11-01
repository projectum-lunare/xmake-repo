-- Projectum Lunare Xmake Repository - forge
-- Category: Build System & Toolchains (Addons)

package("forge")
    set_kind("addon")
    set_homepage("https://github.com/projectum-lunare/forge")
    set_description("Projectum Lunare Unified Build, Toolchain & Cross-Compilation Addon")
    set_license("MPL-2.0")

    add_urls("https://github.com/projectum-lunare/forge.git")
    add_versions("master", "a28aa8c97d01a28ddc82fc2745406bbea63e321d")
    add_versions("v0.1.2", "v0.1.2")
    add_versions("v0.1.1", "v0.1.1")
    add_versions("v0.1.0", "v0.1.0")

    on_test(function (package)
        assert(package:has_addon())
    end)
