# Projectum Lunare Xmake Repository

> **Official package and addon repository for Projectum Lunare**  
> Custom packages, cross-compilation toolchains, and retro-computing dependencies for [Xmake](https://xmake.io).

[![License: MPL 2.0](https://img.shields.io/badge/License-MPL_2.0-blue.svg)](https://opensource.org/licenses/MPL-2.0)
[![Xmake](https://img.shields.io/badge/Xmake-Repository-red.svg)](https://xmake.io)

---

## Adding this Repository

To use packages and addons from this repository in your local environment:

```bash
xmake repo --add projectum-lunare https://github.com/projectum-lunare/xmake-repo.git
```

Or declare it directly in your project's `xmake.lua`:

```lua
add_repositories("projectum-lunare https://github.com/projectum-lunare/xmake-repo.git")
```

---

## Available Packages & Addons

### Categories

- [Build System & Toolchains (Addons)](#build-system-toolchains-addons)
- [Runtimes & Core Language](#runtimes-core-language)
- [OpenResty & NGINX Ecosystem](#openresty-nginx-ecosystem)
- [Languages & Transpilers (Compile-to-Lua)](#languages-transpilers-compile-to-lua)
- [Parsing, Data Formats & Templates](#parsing-data-formats-templates)
- [Testing, Code Quality & Documentation](#testing-code-quality-documentation)
- [Networking, Web & Services](#networking-web-services)
- [Databases & Storage](#databases-storage)
- [System, Hardware & Native Bindings](#system-hardware-native-bindings)
- [CLI, Terminal & Text UI](#cli-terminal-text-ui)
- [Data Structures, Concurrency & Utilities](#data-structures-concurrency-utilities)

---

### Build System & Toolchains (Addons)

| Package | Description | Versions |
| :--- | :--- | :--- |
| [**`forge`**](addons/f/forge/xmake.lua) | Projectum Lunare Unified Build, Toolchain & Cross-Compilation Addon | `master`, `v0.1.1`, `v0.1.0` |

### Runtimes & Core Language

| Package | Description | Versions |
| :--- | :--- | :--- |
| [**`lua`**](packages/l/lua/xmake.lua) | A powerful, efficient, lightweight, embeddable scripting language. | `v5.5.1`, `v5.5.0`, `v5.4.8`, ... |
| [**`elua`**](packages/e/elua/xmake.lua) | Embedded Lua (eLua) offers the full implementation of the Lua language to the embedded world. | `v0.9`, `v0.8`, `v0.7` |
| [**`luvit`**](packages/l/luvit/xmake.lua) | Asynchronous I/O for Lua - Node.js style APIs for luvi as either a luvi app or library. | `2.9.1`, `2.8.0`, `2.7.4` |
| [**`lit`**](packages/l/lit/xmake.lua) | The Luvit Invention Toolkit is a luvi app that handles dependencies and luvi builds. | `3.8.5`, `3.8.4`, `3.8.3` |
| [**`rings`**](packages/r/rings/xmake.lua) | Multiple Lua states from Lua. | `v_1_3_0` |
| [**`lua-compat-5.3`**](packages/l/lua-compat-5.3/xmake.lua) | Compatibility module providing Lua-5.3-style APIs for Lua 5.2 and 5.1. | `v0.15.1`, `v0.15.0` |

### OpenResty & NGINX Ecosystem

| Package | Description | Versions |
| :--- | :--- | :--- |
| [**`lua-cjson`**](packages/l/lua-cjson/xmake.lua) | A fast JSON encoding/parsing module for Lua (OpenResty fork). | `2.1.0.20`, `2.1.0.19`, `2.1.0.18`, ... |
| [**`lua-resty-http`**](packages/l/lua-resty-http/xmake.lua) | Lua HTTP client cosocket driver for OpenResty / ngx_lua. | `v0.18.0`, `v0.17.2` |
| [**`lua-resty-jwt`**](packages/l/lua-resty-jwt/xmake.lua) | JWT (JSON Web Tokens) for ngx_lua and LuaJIT. | `v0.4.0`, `v0.3.2` |

### Languages & Transpilers (Compile-to-Lua)

| Package | Description | Versions |
| :--- | :--- | :--- |
| [**`fennel`**](packages/f/fennel/xmake.lua) | A lisp that compiles to Lua. | `1.6.1`, `1.6.0` |
| [**`moonscript`**](packages/m/moonscript/xmake.lua) | A programmer friendly language that compiles to Lua. | `v0.8.0`, `v0.7.0` |
| [**`yuescript`**](packages/y/yuescript/xmake.lua) | Yuescript is an expressive, concise language transpiling to Lua. | `0.34.3`, `0.34.2`, `0.34.1`, ... |

### Parsing, Data Formats & Templates

| Package | Description | Versions |
| :--- | :--- | :--- |
| [**`lpeg`**](packages/l/lpeg/xmake.lua) | Pattern-Matching for Lua that uses Parsing Expression Grammars (PEGs). | `v1.1.0`, `v1.0.2` |
| [**`lpeglabel`**](packages/l/lpeglabel/xmake.lua) | Parsing Expression Grammars For Lua with Labeled Failures. | `v1.6.2-1`, `v1.6.1-1` |
| [**`dkjson`**](packages/d/dkjson/xmake.lua) | David Kolf's JSON module for Lua. | `2.5`, `2.4` |
| [**`lyaml`**](packages/l/lyaml/xmake.lua) | LibYAML binding for Lua. | `v6.2.9`, `v6.2.8` |
| [**`libyaml`**](packages/l/libyaml/xmake.lua) | A C library for parsing and emitting YAML. | `0.2.5`, `0.2.4` |
| [**`luaexpat`**](packages/l/luaexpat/xmake.lua) | XML Expat parsing for the Lua language. | `1.5.2`, `1.5.1`, `1.5.0`, ... |
| [**`expadom`**](packages/e/expadom/xmake.lua) | Expat based XML DOM level 2 handling for Lua. | `0.1.0` |
| [**`markdown`**](packages/m/markdown/xmake.lua) | Pure Lua implementation of the Markdown text-to-html markup system. | `0.33` |
| [**`inifile`**](packages/i/inifile/xmake.lua) | Simple, complete INI parser for Lua. | `v1.1`, `v1.0` |
| [**`serpent`**](packages/s/serpent/xmake.lua) | Lua serializer and pretty printer. | `0.30`, `0.28` |
| [**`cosmo`**](packages/c/cosmo/xmake.lua) | Safe templates for Lua. | `v16.06.04`, `v10.04.06` |
| [**`etlua`**](packages/e/etlua/xmake.lua) | Embedded templates for Lua. | `v1.3.0`, `v1.2.0` |

### Testing, Code Quality & Documentation

| Package | Description | Versions |
| :--- | :--- | :--- |
| [**`busted`**](packages/b/busted/xmake.lua) | An elegant, extensible testing framework for Lua. | `2.3.0`, `2.2.0`, `2.1.2` |
| [**`luassert`**](packages/l/luassert/xmake.lua) | Lua assertions extension library. | `1.9.0`, `1.8.0` |
| [**`say`**](packages/s/say/xmake.lua) | Simple string key/value store for i18n or any other case where strings need to be stored. | `1.4.1`, `1.4.0` |
| [**`greatest`**](packages/g/greatest/xmake.lua) | A C testing system in one header file | `v1.5.0` |
| [**`luacheck`**](packages/l/luacheck/xmake.lua) | A static analyzer and a linter for Lua. | `v1.2.0`, `v1.1.2`, `v1.1.1` |
| [**`luacov`**](packages/l/luacov/xmake.lua) | Coverage analysis tool for Lua scripts. | `v0.17.0`, `v0.16.0`, `v0.15.0` |
| [**`cluacov`**](packages/c/cluacov/xmake.lua) | C extensions for LuaCov, improving coverage analysis performance. | `1.0.0`, `0.1.4` |
| [**`luacov-reporter-lcov`**](packages/l/luacov-reporter-lcov/xmake.lua) | A luacov reporter for use with lcov. | `v0.2`, `v0.1` |
| [**`ldoc`**](packages/l/ldoc/xmake.lua) | A Lua Documentation Tool. | `v1.5.0`, `1.4.6` |

### Networking, Web & Services

| Package | Description | Versions |
| :--- | :--- | :--- |
| [**`luasocket`**](packages/l/luasocket/xmake.lua) | Network support for the Lua language. | `3.1.0`, `3.0.0` |
| [**`luasec`**](packages/l/luasec/xmake.lua) | A binding for OpenSSL library to provide TLS/SSL communication over LuaSocket. | `1.3.2`, `1.3.1`, `1.3.0`, ... |
| [**`luaossl`**](packages/l/luaossl/xmake.lua) | Most comprehensive OpenSSL binding in the Lua universe. | `20260910`, `20250929`, `20220711` |
| [**`copas`**](packages/c/copas/xmake.lua) | Coroutine Oriented Portable Asynchronous Services for Lua. | `4.12.0`, `4.11.0` |
| [**`lapis`**](packages/l/lapis/xmake.lua) | A web framework for MoonScript and Lua. | `v1.19.0`, `v1.18.0` |
| [**`wsapi`**](packages/w/wsapi/xmake.lua) | WSAPI is an API that abstracts the web server from Lua web applications. | `v1.7`, `v1.6.1` |
| [**`cgilua`**](packages/c/cgilua/xmake.lua) | Tool for creating dynamic Web pages and manipulating data from Web forms. | `6.0.2`, `v5.2.1`, `v5.1.4` |
| [**`orbit`**](packages/o/orbit/xmake.lua) | MVC Web Development for the Kepler platform. | `v2.2.4`, `v2.2.3` |
| [**`lua-mimetypes`**](packages/l/lua-mimetypes/xmake.lua) | A simple library for looking up the MIME types of files. | `v1.1.0`, `v1.0.0` |
| [**`lua-lace`**](packages/l/lua-lace/xmake.lua) | A simple access control engine modelled on Squid's acl syntax. | `v1.4`, `v1.3.1` |

### Databases & Storage

| Package | Description | Versions |
| :--- | :--- | :--- |
| [**`luasql`**](packages/l/luasql/xmake.lua) | Database connectivity for Lua. | `2.8.1`, `2.8.0`, `2.7.0`, ... |
| [**`pgmoon`**](packages/p/pgmoon/xmake.lua) | PostgreSQL driver written in pure Lua. | `v1.18.0`, `v1.17.0` |
| [**`redis-lua`**](packages/r/redis-lua/xmake.lua) | A Lua client library for the Redis key-value storage system. | `v2.0.4`, `v2.0.3` |

### System, Hardware & Native Bindings

| Package | Description | Versions |
| :--- | :--- | :--- |
| [**`luafilesystem`**](packages/l/luafilesystem/xmake.lua) | File System Library for the Lua Language. | `1.9.0`, `1.8.0`, `1.7.0.2`, ... |
| [**`luasystem`**](packages/l/luasystem/xmake.lua) | Platform independent system calls for Lua. | `0.7.1`, `0.7.0` |
| [**`cffi-lua`**](packages/c/cffi-lua/xmake.lua) | A portable C FFI for Lua 5.1+, based on libffi. | `0.2.4`, `0.2.3`, `0.2.2`, ... |
| [**`solo`**](packages/s/solo/xmake.lua) | Physical I/O, System Foundations & Hardware Abstractions | `master` |
| [**`lua-bz2`**](packages/l/lua-bz2/xmake.lua) | A Lua binding to Julian Seward's libbzip2. | `0.2.3`, `0.2.2`, `0.2.1.1`, ... |
| [**`luazip`**](packages/l/luazip/xmake.lua) | Lua extension library used to read files stored inside zip files. | `1.2.7`, `1.2.6` |
| [**`lua-iconv`**](packages/l/lua-iconv/xmake.lua) | Lua binding to the POSIX 'iconv' library. | `7.1.0`, `7.0.0` |
| [**`lualogging`**](packages/l/lualogging/xmake.lua) | A simple API to use logging features in Lua. | `1.8.2`, `1.8.1`, `1.8.0`, ... |
| [**`luasyslog`**](packages/l/luasyslog/xmake.lua) | Syslog logging addon for LuaLogging and standalone syslog access. | `2.0.1`, `2.0.0` |
| [**`magick`**](packages/m/magick/xmake.lua) | Lua bindings to ImageMagick & GraphicsMagick for LuaJIT using FFI. | `v1.6.0`, `v1.5.0` |

### CLI, Terminal & Text UI

| Package | Description | Versions |
| :--- | :--- | :--- |
| [**`argparse`**](packages/a/argparse/xmake.lua) | A feature-rich command line parser for Lua. | `0.7.2`, `0.7.1`, `0.7.0` |
| [**`lua-cliargs`**](packages/l/lua-cliargs/xmake.lua) | A command-line argument parsing module for Lua. | `3.0.2` |
| [**`ansicolors`**](packages/a/ansicolors/xmake.lua) | ANSI terminal color manipulation for Lua. | `v1.0.2` |
| [**`lua-term`**](packages/l/lua-term/xmake.lua) | Terminal manipulation library for Lua. | `0.8`, `0.7` |
| [**`terminal.lua`**](packages/t/terminal.lua/xmake.lua) | Cross platform terminal library for Lua (Windows/Unix/Mac). | `0.1.0` |

### Data Structures, Concurrency & Utilities

| Package | Description | Versions |
| :--- | :--- | :--- |
| [**`penlight`**](packages/p/penlight/xmake.lua) | Lua utility libraries loosely based on the Python standard libraries. | `1.15.0`, `1.14.0`, `1.13.1` |
| [**`middleclass`**](packages/m/middleclass/xmake.lua) | Object orientation for Lua. | `v4.1.1`, `v4.1.0` |
| [**`moses`**](packages/m/moses/xmake.lua) | Utility library for Lua centered around functional programming, similar to Underscore.js. | `2.1.0`, `2.0.0` |
| [**`inspect`**](packages/i/inspect/xmake.lua) | Human-readable representation of Lua tables. | `v3.1.3`, `v3.1.2` |
| [**`date`**](packages/d/date/xmake.lua) | Date & Time module for Lua 5.x. | `2.2.1`, `2.2` |
| [**`basexx`**](packages/b/basexx/xmake.lua) | A base2, base16, base32, base64 and base85 library for Lua. | `v0.4.1`, `v0.4.0` |
| [**`md5`**](packages/m/md5/xmake.lua) | Cryptographic facilities for Lua: MD5 hash function and DES56 encryption. | `1.3` |
| [**`binaryheap`**](packages/b/binaryheap/xmake.lua) | A Binary Heap implementation in pure Lua. | `0.4`, `0.3` |
| [**`timerwheel`**](packages/t/timerwheel/xmake.lua) | A timer wheel implementation in pure Lua. | `1.0.2`, `1.0.1`, `1.0.0` |
| [**`mediator-lua`**](packages/m/mediator-lua/xmake.lua) | A mediator pattern implementation for event-driven systems in Lua. | `1.1.2`, `1.1.1` |
| [**`push`**](packages/p/push/xmake.lua) | Lua library implementing knockout.js-like observable properties. | `v0.1` |
| [**`loadkit`**](packages/l/loadkit/xmake.lua) | Load arbitrary files within the Lua package path. | `v1.1.0`, `v1.0.0` |
| [**`lumen`**](packages/l/lumen/xmake.lua) | Simple concurrent task scheduling and multitasking environment for Lua. | `v1.0` |
| [**`coxpcall`**](packages/c/coxpcall/xmake.lua) | Coroutine-safe xpcall and pcall implementations for Lua. | `1.17.0`, `1.16.0` |

---

## Usage Examples

### Installing Forge Addon
```bash
xmake addon --install forge
```

### Requiring Greatest in `xmake.lua`
```lua
add_requires("greatest")

target("test_suite")
    set_kind("binary")
    add_files("tests/*.c")
    add_packages("greatest")
```

### Requiring LPeg in `xmake.lua`
```lua
add_requires("lpeg")

target("app")
    set_kind("binary")
    add_files("src/*.c")
    add_packages("lpeg")
```

### Requiring Lua (with Retro & Embedded Patches) in `xmake.lua`
```lua
add_requires("lua", {configs = {c89 = true, ["32bits"] = true}})

target("app")
    set_kind("binary")
    add_files("src/*.c")
    add_packages("lua")
```

---

## License

Mozilla Public License Version 2.0 (MPL-2.0). See [LICENSE](LICENSE) for details.
