-- Projectum Lunare Xmake Repository - Nelua Package
-- Category: Languages, Compilers & Systems Programming
-- Nelua: Systems programming language inspired by Lua that compiles to C and WASM
-- Supported Platforms: All platforms supporting C99 (POSIX, Windows, BSD, etc.)

package("nelua")
    set_homepage("https://nelua.io/")
    set_description("Minimal, efficient, statically-typed and meta-programmable systems programming language heavily inspired by Lua, which compiles to C and WebAssembly.")
    set_license("MIT")

    add_urls("https://github.com/edubart/nelua-lang/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/edubart/nelua-lang.git")

    add_versions("20240113", "30e230f275840d35625d086fe47a2e7ded4290c8eb834c273eb58b7fc6270cb6")

    set_kind("binary")
    add_bindirs("bin")

    on_install(function (package)
        local configs = {"PREFIX=" .. package:installdir()}
        import("package.tools.make").build(package, configs)
        import("package.tools.make").make(package, table.join({"install"}, configs))
    end)

    on_test(function (package)
        import("@addon.recudo.lang.nelua").test(package, "print 'hello from nelua package'")
    end)
