-- Projectum Lunare Xmake Repository - PureScript Package
-- Category: Languages, Compilers & Dialects
-- Strongly-typed functional programming language that compiles to JavaScript and Lua (via backends)
-- Supported Platforms: Linux, macOS, Windows

package("purescript")
    set_homepage("https://www.purescript.org/")
    set_description("A strongly-typed functional programming language that compiles to JavaScript and other backends.")
    set_license("BSD-3-Clause")

    if is_plat("linux") then
        if is_arch("arm64", "aarch64") then
            add_urls("https://github.com/purescript/purescript/releases/download/v$(version)/linux-arm64.tar.gz")
            add_versions("0.15.16", "b8d153c5c6e0d8c9618a90824eb342b5818e14a92b0b6cdff753d9b353a927f3")
        else
            add_urls("https://github.com/purescript/purescript/releases/download/v$(version)/linux64.tar.gz")
            add_versions("0.15.16", "44da9efb8a4e14519e8fd5350acc377a4b981e42351a78c53e9f84045bf38e22")
        end
    elseif is_plat("macosx") then
        if is_arch("arm64") then
            add_urls("https://github.com/purescript/purescript/releases/download/v$(version)/macos-arm64.tar.gz")
            add_versions("0.15.16", "63f15a13e226efc260fb025c4a4ad7f66429b6685da607040b7bcc209332fcc4")
        else
            add_urls("https://github.com/purescript/purescript/releases/download/v$(version)/macos.tar.gz")
            add_versions("0.15.16", "9f5bfdb7a468241c7106660bc6bd0209ce3f19ad197516ccdcd5c17df81958b6")
        end
    elseif is_plat("windows") then
        add_urls("https://github.com/purescript/purescript/releases/download/v$(version)/win64.tar.gz")
        add_versions("0.15.16", "8b68ae1031f6aafda327672a424109ff28f8881b0ce00185a2b1445d32430df3")
    end

    set_kind("binary")
    add_bindirs("bin")

    on_install(function (package)
        local bindir = package:installdir("bin")
        os.mkdir(bindir)
        for _, f in ipairs(os.files("purs*")) do
            local name = path.filename(f)
            os.cp(f, bindir)
            if not is_host("windows") then
                os.runv("chmod", {"+x", path.join(bindir, name)})
            end
        end
    end)

    on_test(function (package)
        local purs = path.join(package:installdir("bin"), "purs" .. (is_host("windows") and ".exe" or ""))
        os.vrunv(purs, {"--version"})
    end)
