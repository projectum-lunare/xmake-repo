-- Projectum Lunare Xmake Repository - Pallene Package
-- Category: Languages, Compilers & Dialects
-- A typed, ahead-of-time compiled companion language for Lua (PUC-Rio)
-- Supported Platforms: Linux, macOS, Windows, BSD

package("pallene")
    set_homepage("https://github.com/pallene-lang/pallene")
    set_description("Pallene is a statically-typed, ahead-of-time compiled companion language for Lua.")
    set_license("MIT")

    add_urls("https://github.com/pallene-lang/pallene/archive/$(version).tar.gz")
    add_urls("https://github.com/pallene-lang/pallene.git")

    add_versions("b814ba20021a154be339896c94ade59dfcdcd1e5", "f24ee8298c1f42ed848650b6aec70e9a66b06f75b5da37ac4226d367c4bd19bc")

    add_deps("lpeg", {configs = {shared = true}})
    add_deps("argparse")

    set_kind("library", {headeronly = true})
    add_bindirs("bin")
    add_includedirs("include")

    on_load(function (package)
        import("@addon.recudo.lua.runtime").setup(package, {
            runtime = "lua",
            version = ">=5.4",
            default = "lua",
        })
    end)

    on_install(function (package)
        -- Remove file named 'build' from repo root so xmake can create build/ directory
        os.rm("build")

        -- Patch C.lua to be compatible with Lua 5.5 const loop variables
        io.gsub("src/pallene/C.lua", "for line in input:gmatch", "for raw_line in input:gmatch")
        io.gsub("src/pallene/C.lua", "line = line:match", "local line = raw_line:match")

        -- Fix util.split_ext to match last dot instead of first dot
        io.replace("src/pallene/util.lua",
            'local name, ext = string.match(file_name, "(.-)%.(.*)")',
            'local name, ext = string.match(file_name, "^(.-)%.([^.]+)$")',
            {plain = true})

        -- Allow dots and hyphens in driver.lua filename path validation
        io.replace("src/pallene/driver.lua",
            'if not string.match(name, "^[a-zA-Z0-9_/]+$") then',
            'if not string.match(name, "^[a-zA-Z0-9_/%.-]+$") then',
            {plain = true})

        -- Install ptracer headers
        local incdir = package:installdir("include")
        os.mkdir(incdir)
        if os.isfile("deps/pallene-tracer/src/ptracer.h") then
            os.cp("deps/pallene-tracer/src/ptracer.h", incdir)
        end

        io.writefile("xmake.lua", [[
            target("pallene")
                add_rules("recudo.lua.module")
                add_files("src/pallene/**.lua")

            target("pallenec")
                add_rules("recudo.lua.bin")
                set_values("recudo.lua.entry", "src/bin/pallenec")
                add_files("src/bin/pallenec")
                add_deps("pallene")
        ]])
        import("@addon.recudo.lua.module").install_project(package)
    end)

    on_test(function (package)
        local test_pln = path.join(os.tmpdir(), "test_pallene.pln")
        io.writefile(test_pln, "local test = {}\nfunction test.add(x: integer, y: integer): integer\n    return x + y\nend\nreturn test\n")
        local envs = import("@addon.recudo.lang.base").search_envs(package)
        local prog = path.join(package:installdir("bin"), "pallenec" .. (is_host("windows") and ".cmd" or ""))
        os.vrunv(prog, {test_pln, "--emit-lua"}, {envs = envs})
        os.rm(test_pln)
        os.rm(path.join(os.tmpdir(), "test_pallene.lua"))
    end)
