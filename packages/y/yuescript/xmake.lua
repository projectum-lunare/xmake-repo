-- Projectum Lunare Xmake Repository - YueScript Package
-- Category: Languages & Transpilers (Compile-to-Lua)
-- Yuescript is an expressive, concise language transpiling to Lua (Moonscript dialect)
-- Supported Platforms: Linux, macOS, BSD, Windows

package("yuescript")
    set_homepage("https://github.com/IppClub/YueScript")
    set_description("Yuescript is an expressive, concise language transpiling to Lua.")
    set_license("MIT")

    add_urls("https://github.com/IppClub/YueScript/archive/refs/tags/v$(version).tar.gz")
    add_urls("https://github.com/IppClub/YueScript.git")

    add_versions("0.34.3", "d779acea3261e712b9f2b47126f284e6ffd516e8ea9edec7eea4aedeb4ddc0ee")
    add_versions("0.34.2", "e4ab23930919ca1949bce182916cf54f7cd50b2e6756e221bb407a18746bce8c")
    add_versions("0.34.1", "5c291001b6c210f4220ddf4bef0b0cffc7ba2b1cab4c70bc2e44f924c84db8c2")
    add_versions("0.34.0", "3faf4822588ffbbf908f288aa71112a78a2020ad81e8e55673b5f279e034d82b")


    add_bindirs("bin")

    on_load(function (package)
        import("@addon.recudo.lua.runtime").setup(package, {
            runtime = {"lua", "luajit"},
            default = "lua",
        })
    end)


    on_install(function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.release", "mode.debug")
            add_requires("lua")
            includes("@addon/recudo/recudo.lua")

            target("yue")
                add_rules("recudo.lua.module")
                set_languages("c++20")
                add_defines("YUE_UTF8_IMPL")
                if is_plat("windows") then
                    add_defines("YUE_BUILD_AS_DLL")
                end
                add_includedirs("src", "src/3rdParty")
                add_files("src/yuescript/*.cpp")

            target("yue_bin")
                set_kind("binary")
                set_basename("yue")
                set_languages("c99", "c++20")
                add_defines("YUE_UTF8_IMPL")
                add_includedirs("src", "src/3rdParty")
                add_files("src/yuescript/*.cpp")
                add_files("src/yue.cpp")
                add_files("src/3rdParty/colib/ljson.c")
                add_files(
                    "src/3rdParty/efsw/Debug.cpp",
                    "src/3rdParty/efsw/DirectorySnapshot.cpp",
                    "src/3rdParty/efsw/DirectorySnapshotDiff.cpp",
                    "src/3rdParty/efsw/DirWatcherGeneric.cpp",
                    "src/3rdParty/efsw/FileInfo.cpp",
                    "src/3rdParty/efsw/FileSystem.cpp",
                    "src/3rdParty/efsw/FileWatcher.cpp",
                    "src/3rdParty/efsw/FileWatcherCWrapper.cpp",
                    "src/3rdParty/efsw/FileWatcherGeneric.cpp",
                    "src/3rdParty/efsw/FileWatcherImpl.cpp",
                    "src/3rdParty/efsw/Log.cpp",
                    "src/3rdParty/efsw/Mutex.cpp",
                    "src/3rdParty/efsw/String.cpp",
                    "src/3rdParty/efsw/System.cpp",
                    "src/3rdParty/efsw/Thread.cpp",
                    "src/3rdParty/efsw/Watcher.cpp",
                    "src/3rdParty/efsw/WatcherGeneric.cpp"
                )
                if is_plat("windows") then
                    add_files("src/3rdParty/efsw/platform/win/*.cpp")
                    add_files("src/3rdParty/efsw/FileWatcherWin32.cpp", "src/3rdParty/efsw/WatcherWin32.cpp")
                else
                    add_files("src/3rdParty/efsw/platform/posix/*.cpp")
                end
                if is_plat("macosx") then
                    add_files(
                        "src/3rdParty/efsw/FileWatcherFSEvents.cpp",
                        "src/3rdParty/efsw/FileWatcherKqueue.cpp",
                        "src/3rdParty/efsw/WatcherFSEvents.cpp",
                        "src/3rdParty/efsw/WatcherKqueue.cpp"
                    )
                    add_frameworks("CoreFoundation", "CoreServices")
                    add_syslinks("pthread")
                elseif is_plat("linux") then
                    add_files(
                        "src/3rdParty/efsw/FileWatcherInotify.cpp",
                        "src/3rdParty/efsw/WatcherInotify.cpp"
                    )
                    add_syslinks("pthread", "dl")
                elseif is_plat("bsd") then
                    add_files(
                        "src/3rdParty/efsw/FileWatcherKqueue.cpp",
                        "src/3rdParty/efsw/WatcherKqueue.cpp"
                    )
                    add_syslinks("pthread")
                end
                add_packages("lua")
        ]])
        import("@addon.recudo.lua.module").install_project(package)
    end)

    on_test(function (package)
        if package:config("shared") then
            import("@addon.recudo.lua.module").lua_test(package, [[
                local yue = require("yue")
                assert(yue.version, "yue.version should exist")
                local res = yue.to_lua("local x = 123")
                assert(res:find("123"), "failed to compile yue")
            ]])
        else
            assert(package:check_cxxsnippets({test = [[
                struct lua_State;
                extern "C" int luaopen_yue(struct lua_State *L);
                void test() {
                    luaopen_yue((struct lua_State *)0);
                }
            ]]}))
        end
        os.vrun("yue -v")
    end)
