-- Projectum Lunare Xmake Repository - recudo
-- Category: Build System & Toolchains (Addons)

package("recudo")
    set_kind("addon")
    set_homepage("https://github.com/projectum-lunare/recudo")
    set_description("Projectum Lunare Unified Build, Toolchain & Cross-Compilation Addon")
    set_license("MPL-2.0")

    add_urls("https://github.com/projectum-lunare/recudo.git")
    add_versions("master", "d394d17649b80f8dd77151f5a95e8e4086bf3f58")
    add_versions("v0.2.0", "v0.2.0")

    on_test(function (package)
        assert(package:has_addon())
    end)
