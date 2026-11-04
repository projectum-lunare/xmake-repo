-- Projectum Lunare Xmake Repository - TypeScriptToLua Package
-- Category: Languages, Compilers & Dialects
-- TypeScript to Lua transpiler for modern type-safe Lua programming
-- Supported Platforms: Linux, macOS, Windows

package("typescript-to-lua")
    set_homepage("https://typescripttolua.github.io/")
    set_description("TypeScript to Lua transpiler for modern type-safe Lua programming.")
    set_license("MIT")

    set_kind("binary")
    add_bindirs("bin")

    on_install(function (package)
        import("lib.detect.find_tool")
        local npm = assert(find_tool("npm"), "npm is required to install typescript-to-lua! Please install Node.js/npm.")
        os.vrunv(npm.program, {"install", "-g", "--prefix", package:installdir(), "typescript-to-lua", "typescript"})
    end)

    on_test(function (package)
        local tstl = path.join(package:installdir("bin"), "tstl" .. (is_host("windows") and ".cmd" or ""))
        os.vrunv(tstl, {"--version"})
    end)
