-- Projectum Lunare Xmake Repository - CSharp.lua Package
-- Category: Languages, Compilers & Dialects
-- C# to Lua compiler for game development and Lua scripting
-- Supported Platforms: Linux, macOS, Windows

package("csharp-lua")
    set_homepage("https://github.com/yanghuan/CSharp.lua")
    set_description("CSharp.lua is a C# to Lua compiler for Unity and general Lua game engines.")
    set_license("Apache-2.0")

    add_urls("https://github.com/yanghuan/CSharp.lua/releases/download/$(version)/CSharp.lua-$(version).zip")
    add_versions("2.0", "5ab60431da67fe42e5e7a2870c023a9b0f21ad079744117beae38059d12d46f4")

    set_kind("binary")
    add_bindirs("bin")

    on_install(function (package)
        local sharedir = package:installdir("share/csharp-lua")
        os.mkdir(sharedir)
        os.cp("CSharp.lua", sharedir)
        os.cp("CoreSystem.lua", sharedir)

        local bindir = package:installdir("bin")
        os.mkdir(bindir)

        if is_host("windows") then
            local cmd = format([[@echo off
set CSHARP_LUA_HOME=%%~dp0..\share\csharp-lua\CSharp.lua
"%%CSHARP_LUA_HOME%%\CSharp.lua.Launcher.exe" %%*
]])
            io.writefile(path.join(bindir, "csharp-lua.cmd"), cmd)
        else
            local sh = format([[#!/bin/sh
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
exec dotnet "$SCRIPT_DIR/../share/csharp-lua/CSharp.lua/CSharp.lua.Launcher.dll" "$@"
]])
            local script = path.join(bindir, "csharp-lua")
            io.writefile(script, sh)
            os.runv("chmod", {"+x", script})
        end
    end)

    on_test(function (package)
        local bindir = package:installdir("bin")
        local exe = path.join(bindir, is_host("windows") and "csharp-lua.cmd" or "csharp-lua")
        assert(os.isfile(exe), "csharp-lua launcher not found")
        import("lib.detect.find_tool")
        if is_host("windows") or find_tool("dotnet") then
            os.vrunv(exe, {})
        end
    end)
