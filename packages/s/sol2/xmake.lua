-- Projectum Lunare Xmake Repository - sol2 Package
-- Category: Language Bindings & FFI
-- C++17/C++20 Lua binding library with high performance and ergonomic API
-- Supported Platforms: Linux, macOS, BSD, Windows, Haiku

package("sol2")
    set_kind("library", {headeronly = true})
    set_homepage("https://github.com/ThePhD/sol2")
    set_description("A C++17/C++20 Lua binding library with high performance and ergonomic API.")
    set_license("MIT")

    add_urls("https://github.com/ThePhD/sol2/archive/refs/tags/v$(version).tar.gz")
    add_urls("https://github.com/ThePhD/sol2.git")

    add_versions("3.5.0", "86c0f6d2836b184a250fc2907091c076bf53c9603dd291eaebade36cc342e13c")
    add_versions("3.3.1", "ad121461047d52b449aa84234a6b578fa3ed95d67d1a0703902eba72417f61bb")

    add_deps("lua v5.4.8")

    on_install(function (package)
        os.cp("include/sol", package:installdir("include"))
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            #include <sol/sol.hpp>
            int main() {
                sol::state lua;
                lua.open_libraries(sol::lib::base);
                lua.script("a = 42");
                int a = lua["a"];
                return (a == 42) ? 0 : 1;
            }
        ]]}, {configs = {languages = "c++17"}}))
    end)
