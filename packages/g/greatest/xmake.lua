package("greatest")
    set_kind("library", {headeronly = true})
    set_homepage("https://github.com/silentbicycle/greatest")
    set_description("A C testing system in one header file")
    set_license("ISC")

    add_urls("https://raw.githubusercontent.com/silentbicycle/greatest/$(version)/greatest.h", {version = function (version) return version end})
    add_urls("https://github.com/silentbicycle/greatest.git")

    add_versions("v1.5.0", "v1.5.0")

    on_install(function (package)
        local incdir = package:installdir("include/greatest")
        os.mkdir(incdir)
        if os.isfile("greatest.h") then
            os.cp("greatest.h", path.join(incdir, "greatest.h"))
            os.cp("greatest.h", package:installdir("include/greatest.h"))
        else
            import("net.http")
            http.download("https://raw.githubusercontent.com/silentbicycle/greatest/release/greatest.h", path.join(incdir, "greatest.h"))
            os.cp(path.join(incdir, "greatest.h"), package:installdir("include/greatest.h"))
        end
    end)

    on_test(function (package)
        assert(package:has_cincludes("greatest/greatest.h"))
    end)
