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
- [Game Engines & Creative Coding (LÖVE)](#game-engines--creative-coding-love)
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

| Package | Description |
| :--- | :--- |
| [**`forge`**](addons/f/forge/xmake.lua) | Projectum Lunare Unified Build, Toolchain & Cross-Compilation Addon |

### Runtimes & Core Language

| Package | Description |
| :--- | :--- |
| [**`lua`**](packages/l/lua/xmake.lua) | A powerful, efficient, lightweight, embeddable scripting language. |
| [**`openresty-luajit`**](packages/o/openresty-luajit/xmake.lua) | OpenResty's Branch of LuaJIT 2 with string.buffer, table.new/clear and GC64 support. |
| [**`elua`**](packages/e/elua/xmake.lua) | Embedded Lua (eLua) offers the full implementation of the Lua language to the embedded world. |
| [**`luvit`**](packages/l/luvit/xmake.lua) | Asynchronous I/O for Lua - Node.js style APIs for luvi as either a luvi app or library. |
| [**`lit`**](packages/l/lit/xmake.lua) | The Luvit Invention Toolkit is a luvi app that handles dependencies and luvi builds. |
| [**`rings`**](packages/r/rings/xmake.lua) | Multiple Lua states from Lua. |
| [**`lua-compat-5.3`**](packages/l/lua-compat-5.3/xmake.lua) | Compatibility module providing Lua-5.3-style APIs for Lua 5.2 and 5.1. |

### OpenResty & NGINX Ecosystem

| Package | Description |
| :--- | :--- |
| [**`lua-cjson`**](packages/l/lua-cjson/xmake.lua) | A fast JSON encoding/parsing module for Lua (OpenResty fork). |
| [**`lua-radix-router`**](packages/l/lua-radix-router/xmake.lua) | Fast, lightweight API router based on radix tree for Lua and OpenResty. |
| [**`lua-resty-cookie`**](packages/l/lua-resty-cookie/xmake.lua) | HTTP cookie manipulation for OpenResty/ngx_lua. |
| [**`lua-resty-core`**](packages/l/lua-resty-core/xmake.lua) | New FFI-based Lua API for the ngx_lua module. |
| [**`lua-resty-dns`**](packages/l/lua-resty-dns/xmake.lua) | DNS resolver for the OpenResty / ngx_lua cosocket API. |
| [**`lua-resty-etcd`**](packages/l/lua-resty-etcd/xmake.lua) | Nonblocking Lua etcd driver library for OpenResty. |
| [**`lua-resty-http`**](packages/l/lua-resty-http/xmake.lua) | Lua HTTP client cosocket driver for OpenResty / ngx_lua. |
| [**`lua-resty-http2`**](packages/l/lua-resty-http2/xmake.lua) | HTTP/2 protocol implementation for OpenResty. |
| [**`lua-resty-jwt`**](packages/l/lua-resty-jwt/xmake.lua) | JWT (JSON Web Tokens) for ngx_lua and LuaJIT. |
| [**`lua-resty-limit-traffic`**](packages/l/lua-resty-limit-traffic/xmake.lua) | Lua library to limit and traffic shape in OpenResty/ngx_lua. |
| [**`lua-resty-lock`**](packages/l/lua-resty-lock/xmake.lua) | Simple nonblocking mutex lock for OpenResty based on shared memory. |
| [**`lua-resty-lrucache`**](packages/l/lua-resty-lrucache/xmake.lua) | Lua-land LRU cache based on the LuaJIT FFI. |
| [**`lua-resty-maxminddb`**](packages/l/lua-resty-maxminddb/xmake.lua) | MaxMind GeoIP2 / GeoLite2 database reader library for OpenResty. |
| [**`lua-resty-memcached`**](packages/l/lua-resty-memcached/xmake.lua) | Lua memcached client driver for the ngx_lua based on the cosocket API. |
| [**`lua-resty-mysql`**](packages/l/lua-resty-mysql/xmake.lua) | Nonblocking Lua MySQL driver library for OpenResty. |
| [**`lua-resty-openidc`**](packages/l/lua-resty-openidc/xmake.lua) | OpenID Connect Relying Party and OAuth 2.0 Resource Server for OpenResty. |
| [**`lua-resty-redis`**](packages/l/lua-resty-redis/xmake.lua) | Lua Redis client driver for the ngx_lua based on the cosocket API. |
| [**`lua-resty-requests`**](packages/l/lua-resty-requests/xmake.lua) | Yet Another HTTP library for OpenResty - HTTP library for Humans. |
| [**`lua-resty-session`**](packages/l/lua-resty-session/xmake.lua) | Session library for OpenResty - Flexible and secure sessions. |
| [**`lua-resty-shell`**](packages/l/lua-resty-shell/xmake.lua) | Lua module for nonblocking system shell command executions in OpenResty. |
| [**`lua-resty-signal`**](packages/l/lua-resty-signal/xmake.lua) | POSIX signal library for OpenResty. |
| [**`lua-resty-socket`**](packages/l/lua-resty-socket/xmake.lua) | Automatic LuaSocket/ngx.socket.tcp fallback with identical API. |
| [**`lua-resty-string`**](packages/l/lua-resty-string/xmake.lua) | String utilities and common hash functions for OpenResty. |
| [**`lua-resty-upload`**](packages/l/lua-resty-upload/xmake.lua) | Streaming reading and parsing for HTTP file uploading based on ngx_lua cosockets. |
| [**`lua-resty-websocket`**](packages/l/lua-resty-websocket/xmake.lua) | Lua WebSocket implementation for the ngx_lua module in OpenResty. |
| [**`lua-tablepool`**](packages/l/lua-tablepool/xmake.lua) | Lua table recycling pools for LuaJIT and OpenResty. |
| [**`openresty-luajit`**](packages/o/openresty-luajit/xmake.lua) | OpenResty's Branch of LuaJIT 2 with string.buffer, table.new/clear and GC64 support. |

### Game Engines & Creative Coding (LÖVE)

| Package | Description |
| :--- | :--- |
| [**`love`**](packages/l/love/xmake.lua) | LÖVE is an awesome 2D game framework for Lua (supports both LuaJIT and PUC-Rio Lua 5.1). |
| [**`anim8`**](packages/a/anim8/xmake.lua) | Grid-based 2D sprite animation library for LÖVE. |
| [**`bump`**](packages/b/bump/xmake.lua) | Fast, simple AABB (axis-aligned bounding box) 2D collision detection and resolution library. |
| [**`flux`**](packages/f/flux/xmake.lua) | Fast, lightweight tweening library for Lua. |
| [**`hump`**](packages/h/hump/xmake.lua) | Lightweight game development utilities for LÖVE (camera, timer, vector, gamestate, class, signal). |
| [**`lume`**](packages/l/lume/xmake.lua) | Essential math, table and functional utilities for gamedev in Lua. |
| [**`tween`**](packages/t/tween/xmake.lua) | Small tweening and easing library for Lua with custom interpolation functions. |

### Languages & Transpilers (Compile-to-Lua)

| Package | Description |
| :--- | :--- |
| [**`fennel`**](packages/f/fennel/xmake.lua) | A lisp that compiles to Lua. |
| [**`moonscript`**](packages/m/moonscript/xmake.lua) | A programmer friendly language that compiles to Lua. |
| [**`yuescript`**](packages/y/yuescript/xmake.lua) | Yuescript is an expressive, concise language transpiling to Lua. |

### Parsing, Data Formats & Templates

| Package | Description |
| :--- | :--- |
| [**`lpeg`**](packages/l/lpeg/xmake.lua) | Pattern-Matching for Lua that uses Parsing Expression Grammars (PEGs). |
| [**`lpeglabel`**](packages/l/lpeglabel/xmake.lua) | Parsing Expression Grammars For Lua with Labeled Failures. |
| [**`dkjson`**](packages/d/dkjson/xmake.lua) | David Kolf's JSON module for Lua. |
| [**`lyaml`**](packages/l/lyaml/xmake.lua) | LibYAML binding for Lua. |
| [**`libyaml`**](packages/l/libyaml/xmake.lua) | A C library for parsing and emitting YAML. |
| [**`luaexpat`**](packages/l/luaexpat/xmake.lua) | XML Expat parsing for the Lua language. |
| [**`expadom`**](packages/e/expadom/xmake.lua) | Expat based XML DOM level 2 handling for Lua. |
| [**`markdown`**](packages/m/markdown/xmake.lua) | Pure Lua implementation of the Markdown text-to-html markup system. |
| [**`inifile`**](packages/i/inifile/xmake.lua) | Simple, complete INI parser for Lua. |
| [**`serpent`**](packages/s/serpent/xmake.lua) | Lua serializer and pretty printer. |
| [**`cosmo`**](packages/c/cosmo/xmake.lua) | Safe templates for Lua. |
| [**`etlua`**](packages/e/etlua/xmake.lua) | Embedded templates for Lua. |

### Testing, Code Quality & Documentation

| Package | Description |
| :--- | :--- |
| [**`busted`**](packages/b/busted/xmake.lua) | An elegant, extensible testing framework for Lua. |
| [**`luassert`**](packages/l/luassert/xmake.lua) | Lua assertions extension library. |
| [**`say`**](packages/s/say/xmake.lua) | Simple string key/value store for i18n or any other case where strings need to be stored. |
| [**`greatest`**](packages/g/greatest/xmake.lua) | A C testing system in one header file |
| [**`luacheck`**](packages/l/luacheck/xmake.lua) | A static analyzer and a linter for Lua. |
| [**`luacov`**](packages/l/luacov/xmake.lua) | Coverage analysis tool for Lua scripts. |
| [**`cluacov`**](packages/c/cluacov/xmake.lua) | C extensions for LuaCov, improving coverage analysis performance. |
| [**`luacov-reporter-lcov`**](packages/l/luacov-reporter-lcov/xmake.lua) | A luacov reporter for use with lcov. |
| [**`ldoc`**](packages/l/ldoc/xmake.lua) | A Lua Documentation Tool. |

### Networking, Web & Services

| Package | Description |
| :--- | :--- |
| [**`luasocket`**](packages/l/luasocket/xmake.lua) | Network support for the Lua language. |
| [**`luasec`**](packages/l/luasec/xmake.lua) | A binding for OpenSSL library to provide TLS/SSL communication over LuaSocket. |
| [**`luaossl`**](packages/l/luaossl/xmake.lua) | Most comprehensive OpenSSL binding in the Lua universe. |
| [**`copas`**](packages/c/copas/xmake.lua) | Coroutine Oriented Portable Asynchronous Services for Lua. |
| [**`lapis`**](packages/l/lapis/xmake.lua) | A web framework for MoonScript and Lua. |
| [**`wsapi`**](packages/w/wsapi/xmake.lua) | WSAPI is an API that abstracts the web server from Lua web applications. |
| [**`cgilua`**](packages/c/cgilua/xmake.lua) | Tool for creating dynamic Web pages and manipulating data from Web forms. |
| [**`orbit`**](packages/o/orbit/xmake.lua) | MVC Web Development for the Kepler platform. |
| [**`lua-mimetypes`**](packages/l/lua-mimetypes/xmake.lua) | A simple library for looking up the MIME types of files. |
| [**`lua-lace`**](packages/l/lua-lace/xmake.lua) | A simple access control engine modelled on Squid's acl syntax. |

### Databases & Storage

| Package | Description |
| :--- | :--- |
| [**`luasql`**](packages/l/luasql/xmake.lua) | Database connectivity for Lua. |
| [**`pgmoon`**](packages/p/pgmoon/xmake.lua) | PostgreSQL driver written in pure Lua. |
| [**`redis-lua`**](packages/r/redis-lua/xmake.lua) | A Lua client library for the Redis key-value storage system. |

### System, Hardware & Native Bindings

| Package | Description |
| :--- | :--- |
| [**`luafilesystem`**](packages/l/luafilesystem/xmake.lua) | File System Library for the Lua Language. |
| [**`luasystem`**](packages/l/luasystem/xmake.lua) | Platform independent system calls for Lua. |
| [**`cffi-lua`**](packages/c/cffi-lua/xmake.lua) | A portable C FFI for Lua 5.1+, based on libffi. |
| [**`solo`**](packages/s/solo/xmake.lua) | Physical I/O, System Foundations & Hardware Abstractions |
| [**`lua-bz2`**](packages/l/lua-bz2/xmake.lua) | A Lua binding to Julian Seward's libbzip2. |
| [**`luazip`**](packages/l/luazip/xmake.lua) | Lua extension library used to read files stored inside zip files. |
| [**`lua-iconv`**](packages/l/lua-iconv/xmake.lua) | Lua binding to the POSIX 'iconv' library. |
| [**`lualogging`**](packages/l/lualogging/xmake.lua) | A simple API to use logging features in Lua. |
| [**`luasyslog`**](packages/l/luasyslog/xmake.lua) | Syslog logging addon for LuaLogging and standalone syslog access. |
| [**`magick`**](packages/m/magick/xmake.lua) | Lua bindings to ImageMagick & GraphicsMagick for LuaJIT using FFI. |
| [**`openal-soft`**](packages/o/openal-soft/xmake.lua) | A software implementation of the OpenAL 3D audio API. |

### CLI, Terminal & Text UI

| Package | Description |
| :--- | :--- |
| [**`argparse`**](packages/a/argparse/xmake.lua) | A feature-rich command line parser for Lua. |
| [**`lua-cliargs`**](packages/l/lua-cliargs/xmake.lua) | A command-line argument parsing module for Lua. |
| [**`ansicolors`**](packages/a/ansicolors/xmake.lua) | ANSI terminal color manipulation for Lua. |
| [**`lua-term`**](packages/l/lua-term/xmake.lua) | Terminal manipulation library for Lua. |
| [**`terminal.lua`**](packages/t/terminal.lua/xmake.lua) | Cross platform terminal library for Lua (Windows/Unix/Mac). |

### Data Structures, Concurrency & Utilities

| Package | Description |
| :--- | :--- |
| [**`penlight`**](packages/p/penlight/xmake.lua) | Lua utility libraries loosely based on the Python standard libraries. |
| [**`middleclass`**](packages/m/middleclass/xmake.lua) | Object orientation for Lua. |
| [**`moses`**](packages/m/moses/xmake.lua) | Utility library for Lua centered around functional programming, similar to Underscore.js. |
| [**`inspect`**](packages/i/inspect/xmake.lua) | Human-readable representation of Lua tables. |
| [**`date`**](packages/d/date/xmake.lua) | Date & Time module for Lua 5.x. |
| [**`basexx`**](packages/b/basexx/xmake.lua) | A base2, base16, base32, base64 and base85 library for Lua. |
| [**`md5`**](packages/m/md5/xmake.lua) | Cryptographic facilities for Lua: MD5 hash function and DES56 encryption. |
| [**`binaryheap`**](packages/b/binaryheap/xmake.lua) | A Binary Heap implementation in pure Lua. |
| [**`timerwheel`**](packages/t/timerwheel/xmake.lua) | A timer wheel implementation in pure Lua. |
| [**`mediator-lua`**](packages/m/mediator-lua/xmake.lua) | A mediator pattern implementation for event-driven systems in Lua. |
| [**`push`**](packages/p/push/xmake.lua) | Lua library implementing knockout.js-like observable properties. |
| [**`loadkit`**](packages/l/loadkit/xmake.lua) | Load arbitrary files within the Lua package path. |
| [**`lumen`**](packages/l/lumen/xmake.lua) | Simple concurrent task scheduling and multitasking environment for Lua. |
| [**`coxpcall`**](packages/c/coxpcall/xmake.lua) | Coroutine-safe xpcall and pcall implementations for Lua. |
| [**`lua-typeof`**](packages/l/lua-typeof/xmake.lua) | Type check library for Lua. |

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

### Building a Standalone Game with LÖVE & Libraries in `xmake.lua`
```lua
add_rules("mode.debug", "mode.release")

add_requires("love")
add_requires("anim8", "bump", "hump", "flux", "tween", "lume")
add_requires("forge master", {kind = "addon"})

includes("@addon/forge/forge.lua")

target("mygame")
    add_rules("forge.love")
    add_packages("love", "anim8", "bump", "hump", "flux", "tween", "lume")
    add_files("src/main.lua")
```

- **Dev mode (`xmake run`)**: runs your game interpreting directly from `src/` with automatic package search paths.
- **Release mode (`xmake -m release`)**: fuses the executable with all game assets and bundled Lua modules into a standalone binary.

---

## License

Mozilla Public License Version 2.0 (MPL-2.0). See [LICENSE](LICENSE) for details.
