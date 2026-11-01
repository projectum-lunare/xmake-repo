add_rules("mode.release", "mode.debug")

add_requires("libsdl2", "freetype")

target("amulet")
    set_kind("static")
    add_packages("libsdl2", "freetype")

    add_includedirs(
        "src",
        "third_party/glm-0.9.7.1",
        "third_party/stb",
        "third_party/kiss_fft130",
        "third_party/tinymt-1.0.3",
        "third_party/simpleopt",
        "third_party/lua-5.1.5/src"
    )

    add_headerfiles(
        "src/amulet.h",
        "src/am_engine.h",
        "src/c99.h",
        "third_party/lua-5.1.5/src/(lua.h)",
        "third_party/lua-5.1.5/src/(luaconf.h)",
        "third_party/lua-5.1.5/src/(lauxlib.h)",
        "third_party/lua-5.1.5/src/(lualib.h)",
        "third_party/stb/(**.h)",
        "third_party/kiss_fft130/(**.h)",
        "third_party/tinymt-1.0.3/(**.h)",
        "third_party/simpleopt/(**.h)",
        "third_party/glm-0.9.7.1/(glm/**.hpp)",
        "third_party/glm-0.9.7.1/(glm/**.inl)",
        "third_party/glm-0.9.7.1/(glm/**.h)"
    )

    if is_plat("linux") then
        if is_arch("x86_64") then
            add_defines("AM_LINUX64")
        else
            add_defines("AM_LINUX32")
        end
    elseif is_plat("macosx") then
        add_defines("AM_OSX")
    elseif is_plat("windows") then
        add_defines("AM_WINDOWS")
    end

    if is_mode("debug") then
        add_defines("AM_DEBUG")
    else
        add_defines("AM_RELEASE")
    end

    add_defines("AM_LUA51")
    add_defines("main=am_main")

    -- Bundled Lua 5.1 runtime
    add_files("third_party/lua-5.1.5/src/*.c|lua.c|luac.c|print.c")

    -- Third-party components
    add_files(
        "third_party/stb/miniz.c",
        "third_party/stb/stb_image.c",
        "third_party/stb/stb_vorbis.c",
        "third_party/kiss_fft130/kiss_fft.c",
        "third_party/kiss_fft130/kiss_fftr.c",
        "third_party/tinymt-1.0.3/tinymt32.c"
    )

    -- Amulet core sources
    add_files("src/*.cpp|am_backend_android.cpp|am_backend_emscripten.cpp|am_backend_ios.cpp|am_videocapture_osx.cpp")
    if is_plat("macosx") then
        add_files("src/am_videocapture_osx.cpp")
    end

    if is_plat("linux", "macosx", "bsd") then
        add_cflags("-fno-strict-aliasing", "-Wno-error")
        add_cxflags("-fno-strict-aliasing", "-Wno-error")
        add_syslinks("GL", "dl", "m", "pthread")
    end

    on_load(function (target)
        -- 1. Apply preload & custom init hook patches if not already patched
        local util_file = "src/am_lua_util.cpp"
        if os.isfile(util_file) then
            local content = io.readfile(util_file)
            if not content:find("check_package_preload", 1, true) and not content:find("package.preload for preloaded", 1, true) then
                local target_str = "lua_pop(L, 1); // nil\n\n    // create exports table and add to module table:"
                local replacement_str = [[lua_pop(L, 1); // nil

    // Check package.preload for preloaded C or Lua modules
    lua_getglobal(L, "package");
    if (lua_istable(L, -1)) {
        lua_getfield(L, -1, "preload");
        if (lua_istable(L, -1)) {
            lua_pushvalue(L, 1);
            lua_gettable(L, -2);
            if (lua_isfunction(L, -1)) {
                lua_pushvalue(L, 1);
                lua_call(L, 1, 1);
                // Save returned module in AM_MODULE_TABLE
                lua_pushvalue(L, 1);
                lua_pushvalue(L, -2);
                lua_rawset(L, -5);
                lua_insert(L, 1);
                lua_settop(L, 1);
                return 1;
            }
            lua_pop(L, 1);
        }
        lua_pop(L, 1);
    }
    lua_pop(L, 1);

    // create exports table and add to module table:]]
                if content:find(target_str, 1, true) then
                    content = content:gsub(target_str, replacement_str, 1)
                    io.writefile(util_file, content)
                end
            end
        end

        local engine_cpp = "src/am_engine.cpp"
        if os.isfile(engine_cpp) then
            local content = io.readfile(engine_cpp)
            if not content:find("am_custom_engine_init_hook", 1, true) then
                local hook_decl = [[#ifdef __cplusplus
extern "C" {
#endif
typedef void (*am_engine_init_hook_t)(lua_State *L);
am_engine_init_hook_t am_custom_engine_init_hook = NULL;
void am_set_custom_init_hook(am_engine_init_hook_t hook) {
    am_custom_engine_init_hook = hook;
}
#ifdef __cplusplus
}
#endif

am_engine *am_init_engine(bool worker, int argc, char** argv) {]]

                content = content:gsub("am_engine %*am_init_engine%(bool worker, int argc, char%*%* argv%) %{", hook_decl, 1)

                local hook_call = [[    if (!run_embedded_scripts(L, worker)) {
        lua_close(L);
        return NULL;
    }
    if (am_custom_engine_init_hook) {
        am_custom_engine_init_hook(L);
    }
    return eng;]]

                local old_call = [[    if (!run_embedded_scripts(L, worker)) {
        lua_close(L);
        return NULL;
    }
    return eng;]]

                content = content:gsub(old_call, hook_call, 1)
                io.writefile(engine_cpp, content)
            end
        end

        local engine_h = "src/am_engine.h"
        if os.isfile(engine_h) then
            local content = io.readfile(engine_h)
            if not content:find("am_set_custom_init_hook", 1, true) then
                content = [[struct am_allocator;
struct lua_State;

]] .. content .. [[

#ifdef __cplusplus
extern "C" {
#endif
typedef void (*am_engine_init_hook_t)(struct lua_State *L);
void am_set_custom_init_hook(am_engine_init_hook_t hook);
#ifdef __cplusplus
}
#endif
]]
                io.writefile(engine_h, content)
            end
        end

        -- 2. Generate am_generated_view_defs.inc
        local inc_content = [[
#define TNAME ubyte
#define CTYPE uint8_t
#define MINVAL 0
#define MAXVAL UINT8_MAX
#include "am_clamped_view_template.inc"

#define TNAME byte
#define CTYPE int8_t
#define MINVAL INT8_MIN
#define MAXVAL INT8_MAX
#include "am_clamped_view_template.inc"

#define TNAME ushort
#define CTYPE uint16_t
#define MINVAL 0
#define MAXVAL UINT16_MAX
#include "am_clamped_view_template.inc"

#define TNAME short
#define CTYPE int16_t
#define MINVAL INT16_MIN
#define MAXVAL INT16_MAX
#include "am_clamped_view_template.inc"

#define TNAME ubyte_norm
#define CTYPE uint8_t
#define MINVAL 0
#define MAXVAL UINT8_MAX
#include "am_normalized_view_template.inc"

#define TNAME byte_norm
#define CTYPE int8_t
#define MINVAL INT8_MIN
#define MAXVAL INT8_MAX
#include "am_normalized_view_template.inc"

#define TNAME ushort_norm
#define CTYPE uint16_t
#define MINVAL 0
#define MAXVAL UINT16_MAX
#include "am_normalized_view_template.inc"

#define TNAME short_norm
#define CTYPE int16_t
#define MINVAL INT16_MIN
#define MAXVAL INT16_MAX
#include "am_normalized_view_template.inc"
]]
        io.writefile("src/am_generated_view_defs.inc", inc_content)

        -- 3. Generate am_version.cpp
        io.writefile("src/am_version.cpp", 'const char *am_version = "v1.9.4";\n')

        -- 4. Generate am_embedded_data.cpp
        local files = os.files("lua/*.lua")
        table.sort(files)
        local pngs = os.files("lua/*.png")
        table.sort(pngs)
        for _, p in ipairs(pngs) do
            table.insert(files, p)
        end

        local cpp = io.open("src/am_embedded_data.cpp", "w")
        cpp:write('#include "amulet.h"\n\n')
        for i, filepath in ipairs(files) do
            local f = io.open(filepath, "rb")
            local data = f:read("*a")
            f:close()
            cpp:write(string.format("static const uint8_t data%d[] = {\n    ", i))
            local count = 0
            for j = 1, #data do
                cpp:write(string.format("0x%02X, ", data:byte(j)))
                count = count + 1
                if count == 20 then
                    cpp:write("\n    ")
                    count = 0
                end
            end
            cpp:write("0};\n\n")
        end

        cpp:write("am_embedded_file_record am_embedded_files[] = {")
        for i, filepath in ipairs(files) do
            local name = filepath:gsub("\\", "/")
            cpp:write(string.format('\n    {"%s", data%d, sizeof(data%d)-1},', name, i, i))
        end
        cpp:write("\n    {NULL, NULL, 0}\n};\n")
        cpp:close()

        -- Explicitly register generated cpp files
        target:add("files", "src/am_version.cpp", "src/am_embedded_data.cpp")
    end)

target("amulet_bin")
    set_kind("binary")
    set_basename("amulet")
    add_deps("amulet")
    add_packages("libsdl2", "freetype")
    add_includedirs("src", "third_party/lua-5.1.5/src")
    if is_plat("linux", "macosx", "bsd") then
        add_syslinks("GL", "dl", "m", "pthread")
    end
    on_load(function (target)
        io.writefile(path.join(target:autogendir(), "main.cpp"), [[
extern int am_main(int argc, char *argv[]);
int main(int argc, char *argv[]) {
    return am_main(argc, argv);
}
]])
        target:add("files", path.join(target:autogendir(), "main.cpp"))
    end)
