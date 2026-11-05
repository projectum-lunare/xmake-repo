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
    add_versions("v0.2.4", "v0.2.4")
    add_versions("v0.2.5", "v0.2.5")
    add_versions("v0.2.6", "v0.2.6")
    add_versions("v0.2.7", "v0.2.7")
    add_versions("v0.2.8", "v0.2.8")
    add_versions("v0.2.9", "v0.2.9")

    on_test(function (package)
        assert(package:has_addon())
    end)
