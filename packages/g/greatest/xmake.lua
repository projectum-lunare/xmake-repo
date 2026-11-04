-- Projectum Lunare Xmake Repository - greatest
-- Category: Testing, Code Quality & Documentation

package("greatest")
    set_kind("library", {headeronly = true})
    set_homepage("https://github.com/silentbicycle/greatest")
    set_description("A C testing system in one header file")
    set_license("ISC")

    add_urls("https://github.com/silentbicycle/greatest/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/silentbicycle/greatest.git")

    add_versions("v1.5.0", "33e4c93b1b7f631fec173b8675582d1739b1238a5440b7f4ad50582f0cf38c34")

    on_install(function (package)
        os.cp("greatest.h", package:installdir("include"))
        os.cp("greatest.h", package:installdir("include/greatest"))
    end)

    on_test(function (package)
        assert(package:has_cincludes("greatest/greatest.h"))
    end)
