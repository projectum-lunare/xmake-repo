-- Projectum Lunare Xmake Repository - Haxe Package
-- Category: Languages, Compilers & Multi-Target Toolkits
-- Haxe: An open-source, multi-paradigm high-level language and cross-compiler
-- Supported Platforms: Linux, macOS, Windows

package("haxe")
    set_kind("binary")
    set_homepage("https://haxe.org/")
    set_description("The Haxe Cross-Platform Toolkit")
    set_license("GPL-2.0")

    if is_host("windows") and os.arch() == "x64" then
        add_urls("https://github.com/HaxeFoundation/haxe/releases/download/$(version)/haxe-$(version)-win64.zip")
        add_versions("4.3.7", "29f7acb0fb9fc66a2b9f6bd9453af3474ccb14ebd9fd0142f351d7311c4010c9")
    elseif is_host("macosx") then
        add_urls("https://github.com/HaxeFoundation/haxe/releases/download/$(version)/haxe-$(version)-osx.tar.gz")
        add_versions("4.3.7", "1d355cb28bc25784b33acce023caeb28d50ccb14e953134a62b889697947efdc")
    else
        add_urls("https://github.com/HaxeFoundation/haxe/releases/download/$(version)/haxe-$(version)-linux64.tar.gz")
        add_versions("4.3.7", "a156b3d039daa572f1f9329870ee753e3c39b7514fe8c818069323579659acca")
    end

    add_bindirs("bin")

    on_install(function (package)
        local root = "."
        if not os.isfile("haxe") and not os.isfile("haxe.exe") then
            local matches = os.files("**/haxe")
            if #matches == 0 then
                matches = os.files("**/haxe.exe")
            end
            if #matches > 0 then
                root = path.directory(matches[1])
            end
        end

        local bindir = package:installdir("bin")
        os.mkdir(bindir)
        for _, name in ipairs({"haxe", "haxe.exe", "haxelib", "haxelib.exe"}) do
            local src = path.join(root, name)
            if os.isfile(src) then
                os.cp(src, bindir)
                if not name:endswith(".exe") then
                    os.vrunv("chmod", {"+x", path.join(bindir, name)})
                end
            end
        end
        local stddir = path.join(root, "std")
        if os.isdir(stddir) then
            os.cp(stddir, package:installdir())
        end
        package:addenv("HAXE_STD_PATH", "std")
    end)

    on_test(function (package)
        import("@addon.recudo.lang.haxe").test(package)
    end)
