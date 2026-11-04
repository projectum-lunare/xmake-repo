-- Projectum Lunare Xmake Repository - recudo
-- Category: Build System & Toolchains (Addons)

package("recudo")
    set_kind("addon")
    set_homepage("https://github.com/projectum-lunare/recudo")
    set_description("Projectum Lunare Unified Build, Toolchain & Cross-Compilation Addon")
    set_license("MPL-2.0")

    add_urls("https://github.com/projectum-lunare/recudo.git")
    -- semver only: a branch name in add_versions makes xmake fail with
    -- "unable to parse semver". `master` stays reachable as a git ref.
    add_versions("v0.2.0", "v0.2.0")
    add_versions("v0.2.1", "v0.2.1")
    add_versions("v0.2.2", "v0.2.2")
    add_versions("v0.2.3", "v0.2.3")

    on_test(function (package)
        assert(package:has_addon())
    end)
