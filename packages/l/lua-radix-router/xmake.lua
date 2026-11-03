-- Projectum Lunare Xmake Repository - lua-radix-router Package
-- Category: OpenResty & NGINX Ecosystem
-- Fast, lightweight API router based on radix tree for Lua and OpenResty
-- Supported Platforms: Linux, macOS, BSD, Windows, WinCE, DOS, OS/2, AmigaOS, Atari ST, KolibriOS, Plan 9, WASM/WASI

package("lua-radix-router")
    set_homepage("https://github.com/vm-001/lua-radix-router")
    set_description("Fast, lightweight API router based on radix tree for Lua and OpenResty.")
    set_license("BSD-2-Clause")

    add_urls("https://github.com/vm-001/lua-radix-router/archive/refs/tags/$(version).tar.gz")
    add_urls("https://github.com/vm-001/lua-radix-router.git")

    add_versions("v0.6.2", "1d5211d2802cae785fffc5147f2c55f11a576ca882f71659c2919333b5dd3867")
    add_versions("v0.6.1", "0f687edda554eeee82c82f03654046be3c5d500800f68f4207f82f8bf3902423")
    add_versions("v0.6.0", "a641fa9d33e18c6e568c439ae23f2620538bf31a75807562785bb17a938518b0")

    add_deps("lua")
    add_deps("recudo master", {kind = "addon"})

    on_install(function (package)
        os.mkdir("lib/radix-router")
        os.cp("src/*.lua", "lib/radix-router/")
        os.cp("src/router.lua", "lib/radix-router/init.lua")
        os.cp("src/parser", "lib/radix-router/")
        os.cp("src/parser/parser.lua", "lib/radix-router/parser.lua")
        os.cp("src/matcher", "lib/radix-router/")
        os.cp("src/matcher/matcher.lua", "lib/radix-router/matcher.lua")

        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            includes("@addon/recudo/recudo.lua")

            target("lua-radix-router")
                add_rules("recudo.lua.module")
                add_packages("lua")
                add_files("lib/**.lua")
        ]])
        import("@addon.recudo.lua.module").install_project(package)
    end)

    on_test(function (package)
        import("@addon.recudo.lua.module").lua_test(package, [[
            _G.ngx = {
                re = {
                    find = function(str, regex)
                        return 1, #str
                    end
                }
            }
            local Router = require("radix-router")
            local router, err = Router.new({
                {
                    paths = { "/foo", "/foo/bar", "/html/index.html" },
                    handler = "1"
                },
                {
                    paths = { "/users/{id}/profile-{year}.{format}" },
                    handler = "2"
                }
            })
            assert(router, err)
            assert("1" == router:match("/html/index.html"))
            local params = {}
            local matched = router:match("/users/100/profile-2023.pdf", nil, params)
            assert("2" == matched)
            assert(params.year == "2023")
            assert(params.format == "pdf")
        ]])
    end)
