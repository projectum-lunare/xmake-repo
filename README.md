# Projectum Lunare Xmake Repository

> **Official package and addon repository for Projectum Lunare**  
> Lua packages wired for the Recudo module model, multi-runtime engines, language transpilers, and cross-platform native extensions for [Xmake](https://xmake.io).

[![License: MPL 2.0](https://img.shields.io/badge/License-MPL_2.0-blue.svg)](https://opensource.org/licenses/MPL-2.0)
[![Xmake](https://img.shields.io/badge/Xmake-Repository-red.svg)](https://xmake.io)
[![Packages](https://img.shields.io/badge/Packages-146%20Available-green.svg)](#package-directory)
[![Addon: Recudo](https://img.shields.io/badge/Addon-Recudo%20v0.2.3-orange.svg)](addons/r/recudo/xmake.lua)
[![Platforms](https://img.shields.io/badge/Platforms-Linux%20%7C%20macOS%20%7C%20Windows%20%7C%20BSD%20%7C%20WASM-lightgrey.svg)](#getting-started)

Every recipe in this repository is designed around **Projectum Lunare**'s engineering principles:
* **Recudo Module Model**: Modules install exactly where Lua's `require()` searches. Native extensions are identified by a deterministic runtime `buildhash`.
* **Multi-Runtime ABI Isolation**: Seamlessly switch between PUC-Rio Lua (5.1 / 5.2 / 5.3 / 5.4 / 5.5), LuaJIT 2.1, and OpenResty LuaJIT without ABI conflicts or recipe forks.
* **Dialect & Transpiler Ecosystem**: Native Xmake integration for modern languages transpiling to Lua (Pluto, Teal, Nelua, TypeScript-to-Lua, Erde, Pallene, Fennel, MoonScript, Yuescript, PureScript, CSharp.lua).
* **Multi-Backend Compilers**: First-class support for Haxe and NekoVM compiled from source with modular configurations.
* **Deterministic Source Builds**: Builds tools and native extensions directly from upstream source code with reproducible dependency graphs and zero system pollution.

> [!NOTE]
> Cross-compilation toolchains do **not** live in this repository — they ship inside [`projectum-lunare/recudo`](https://github.com/projectum-lunare/recudo) under `repository/tools/` and are installed with `xmake recudo tool install`.

---

## Table of Contents

- [Getting Started](#getting-started)
  - [Adding this Repository](#adding-this-repository)
  - [Declaring in Project Manifest](#declaring-in-project-manifest)
- [Package Directory](#package-directory)
  - [Build System & Toolchains (Addons)](#build-system--toolchains-addons)
  - [Runtimes & Virtual Machines](#runtimes--virtual-machines)
  - [Languages, Compilers & Transpilers](#languages-compilers--transpilers)
  - [Game Development & Creative Coding](#game-development--creative-coding)
    - [Game Engines & Frameworks](#game-engines--frameworks)
    - [LÖVE (Love2D) Ecosystem](#löve-love2d-ecosystem)
    - [Game Math, Physics & Utilities (Engine-Agnostic)](#game-math-physics--utilities-engine-agnostic)
  - [GUI, Canvas & Graphics (Tecgraf Suite)](#gui-canvas--graphics-tecgraf-suite)
  - [Parsing, Data Formats & Serialization](#parsing-data-formats--serialization)
  - [Networking, Web & Services](#networking-web--services)
    - [Core Networking, Sockets & TLS](#core-networking-sockets--tls)
    - [Web Frameworks & Server Interfaces (WSAPI & Kepler)](#web-frameworks--server-interfaces-wsapi--kepler)
    - [OpenResty & NGINX Ecosystem](#openresty--nginx-ecosystem)
  - [Databases & Storage](#databases--storage)
  - [System, Hardware & Native Extensions](#system-hardware--native-extensions)
  - [Testing, Quality & Tooling](#testing-quality--tooling)
  - [CLI, Terminal & Text UI](#cli-terminal--text-ui)
  - [Data Structures, Concurrency & Utilities](#data-structures-concurrency--utilities)
- [Usage & Architecture Examples](#usage--architecture-examples)
  - [1. Installing & Using the Recudo Addon](#1-installing--using-the-recudo-addon)
  - [2. Multi-Runtime Selection (PUC-Lua vs LuaJIT vs OpenResty)](#2-multi-runtime-selection-puc-lua-vs-luajit-vs-openresty)
  - [3. Requiring Dialects & Transpilers in `xmake.lua`](#3-requiring-dialects--transpilers-in-xmakelua)
  - [4. Multi-Backend Haxe Compilation (Native C++ & Lua)](#4-multi-backend-haxe-compilation-native-c--lua)
  - [5. Building Standalone Games with LÖVE & Libraries](#5-building-standalone-games-with-löve--libraries)
  - [6. Native C & C++ Libraries in `xmake.lua`](#6-native-c--c-libraries-in-xmakelua)
  - [7. Embedded Lua & Retro Platform Configurations](#7-embedded-lua--retro-platform-configurations)
  - [8. Auditing Recipes with Package Linter](#8-auditing-recipes-with-package-linter)
- [License](#license)

---

## Getting Started

### Adding this Repository

Register the repository in your local Xmake environment:

```bash
xmake repo --add projectum-lunare https://github.com/projectum-lunare/xmake-repo.git
```

Update your registered repositories anytime with:

```bash
xmake repo -u
```

### Declaring in Project Manifest

Declare this repository directly in your project's `xmake.lua` to ensure fully reproducible, portable builds across machines and CI pipelines:

```lua
add_repositories("projectum-lunare https://github.com/projectum-lunare/xmake-repo.git")
```

---

## Package Directory

> [!NOTE]
> Packages marked with **`🗄️`** indicate that the upstream repository was archived or frozen by its original author, but is fully maintained, compatible, and verified with automated test suites within this repository.

### Build System & Toolchains (Addons)

| Package | Description |
| :--- | :--- |
| [**`recudo`**](addons/r/recudo/xmake.lua) | Projectum Lunare Unified Build, Toolchain & Cross-Compilation Addon for Xmake. |

### Runtimes & Virtual Machines

| Package | Description |
| :--- | :--- |
| [**`lua`**](packages/l/lua/xmake.lua) | A powerful, efficient, lightweight, embeddable scripting language (PUC-Rio Lua 5.1, 5.2, 5.3, 5.4, 5.5). |
| [**`openresty-luajit`**](packages/o/openresty-luajit/xmake.lua) | OpenResty's branch of LuaJIT 2 with `string.buffer`, `table.new`/`clear`, and GC64 support. |
| [**`neko`**](packages/n/neko/xmake.lua) | High-level dynamically typed programming language and lightweight virtual machine by Haxe Foundation. |
| [**`elua`**](packages/e/elua/xmake.lua) | Embedded Lua (eLua) offering the full implementation of the Lua language to microcontrollers and bare metal. |
| [**`luvit`**](packages/l/luvit/xmake.lua) | Asynchronous I/O for Lua - Node.js style APIs for luvi as either a standalone binary or library. |
| [**`lit`**](packages/l/lit/xmake.lua) | The Luvit Invention Toolkit - packaging and dependency management for luvi applications. |
| [**`rings`**](packages/r/rings/xmake.lua) | Multiple isolated Lua states executed safely from within a master Lua state. |
| [**`lua-compat-5.3`**](packages/l/lua-compat-5.3/xmake.lua) | Comprehensive compatibility module providing Lua-5.3-style C and Lua APIs for Lua 5.2 and 5.1. |
| [**`bit32`**](packages/b/bit32/xmake.lua) 🗄️ | Lua 5.2 bit manipulation library backported to Lua 5.1 (upstream feature-complete). |

### Languages, Compilers & Transpilers

| Package | Description |
| :--- | :--- |
| [**`csharp-lua`**](packages/c/csharp-lua/xmake.lua) | C# to Lua compiler for Unity and general Lua game engines. |
| [**`erde`**](packages/e/erde/xmake.lua) | Ergonomic, modern language that transpiles to efficient Lua. |
| [**`fennel`**](packages/f/fennel/xmake.lua) | A clean, elegant Lisp dialect that compiles to Lua with zero runtime overhead. |
| [**`haxe`**](packages/h/haxe/xmake.lua) | High-level, strictly-typed multi-target programming language with C++, Lua, and Neko backends. |
| [**`hxcpp`**](packages/h/hxcpp/xmake.lua) | Runtime support and native C++ backend for the Haxe compiler. |
| [**`moonscript`**](packages/m/moonscript/xmake.lua) | Expressive programmer-friendly language that compiles into Lua code. |
| [**`nelua`**](packages/n/nelua/xmake.lua) | Statically-typed, meta-programmable systems programming language inspired by Lua that compiles to C and WASM. |
| [**`pallene`**](packages/p/pallene/xmake.lua) | Ahead-of-time compiled, statically-typed sister language to Lua designed for high performance. |
| [**`pluto`**](packages/p/pluto/xmake.lua) | Modern, general-purpose superset of Lua 5.5 featuring classes, type annotations, and pattern matching. |
| [**`purescript`**](packages/p/purescript/xmake.lua) | Strongly-typed purely-functional programming language compiling to JavaScript and Lua. |
| [**`tl`**](packages/t/tl/xmake.lua) | Teal, a typed dialect of Lua with compile-time type checking and transpilation to standard Lua. |
| [**`typescript-to-lua`**](packages/t/typescript-to-lua/xmake.lua) | TypeScript to Lua transpiler for modern, type-safe Lua game and application development. |
| [**`yuescript`**](packages/y/yuescript/xmake.lua) | Concise and expressive language transpiling to Lua (modern MoonScript successor in C++). |

### Game Development & Creative Coding

#### Game Engines & Frameworks

| Package | Description |
| :--- | :--- |
| [**`love`**](packages/l/love/xmake.lua) | LÖVE (Love2D) 2D game framework for Lua (supports both LuaJIT and PUC-Rio Lua 5.1). |
| [**`amulet`**](packages/a/amulet/xmake.lua) | Lua-based audio/visual game toolkit and engine for small games, rapid prototyping, and creative coding. |

#### LÖVE (Love2D) Ecosystem

| Package | Description |
| :--- | :--- |
| [**`anim8`**](packages/a/anim8/xmake.lua) | Grid-based 2D sprite animation library designed for LÖVE and generic 2D games. |
| [**`hump`**](packages/h/hump/xmake.lua) | Essential game development utilities for LÖVE (camera, timer, vector, gamestate, class, signal). |
| [**`sti`**](packages/s/sti/xmake.lua) | Simple Tiled Implementation (STI) map loader and renderer for Lua and LÖVE. |

#### Game Math, Physics & Utilities (Engine-Agnostic)

| Package | Description |
| :--- | :--- |
| [**`bump`**](packages/b/bump/xmake.lua) | Fast, simple AABB (axis-aligned bounding box) 2D collision detection and resolution library. |
| [**`cpml`**](packages/c/cpml/xmake.lua) | Cirno's Perfect Math Library: 2D and 3D game math (vectors, matrices, quaternions, geometry). |
| [**`flux`**](packages/f/flux/xmake.lua) | Fast, lightweight tweening and animation library for Lua. |
| [**`hc`**](packages/h/hc/xmake.lua) | General purpose 2D collision detection using Separating Axis Theorem (SAT) and GJK. |
| [**`lume`**](packages/l/lume/xmake.lua) | Essential mathematical, functional, and table utility collection tailored for game developers. |
| [**`tween`**](packages/t/tween/xmake.lua) | Small tweening and easing library with custom interpolation curves. |

### GUI, Canvas & Graphics (Tecgraf Suite)

| Package | Description |
| :--- | :--- |
| [**`iup`**](packages/i/iup/xmake.lua) | Multi-platform toolkit for building native graphical user interfaces (Tecgraf/PUC-Rio). |
| [**`cd`**](packages/c/cd/xmake.lua) | 2D Graphics Canvas Draw toolkit supporting multiple display drivers (Tecgraf/PUC-Rio). |
| [**`im`**](packages/i/im/xmake.lua) | Image representation, storage, capture, processing, and analysis toolkit (Tecgraf/PUC-Rio). |
| [**`magick`**](packages/m/magick/xmake.lua) | Lua bindings to ImageMagick & GraphicsMagick for LuaJIT using FFI. |

### Parsing, Data Formats & Serialization

| Package | Description |
| :--- | :--- |
| [**`lua-cjson`**](packages/l/lua-cjson/xmake.lua) | Ultra-fast JSON encoding and parsing module for Lua in pure C (maintained OpenResty fork). |
| [**`lua-protobuf`**](packages/l/lua-protobuf/xmake.lua) | High-performance Google Protocol Buffers implementation for Lua in pure C. |
| [**`lua-cmsgpack`**](packages/l/lua-cmsgpack/xmake.lua) | Fast self-contained MessagePack serializer and deserializer for Lua in C. |
| [**`lua-toml`**](packages/l/lua-toml/xmake.lua) | Simple, compliant TOML parser and serializer for Lua. |
| [**`lua-zlib`**](packages/l/lua-zlib/xmake.lua) | Complete streaming zlib (deflate/inflate and gzip) compression binding for Lua in C. |
| [**`hx-lua-simdjson`**](packages/h/hx-lua-simdjson/xmake.lua) | High-performance JSON parsing binding based on simdjson for Lua and Haxe. |
| [**`dkjson`**](packages/d/dkjson/xmake.lua) | David Kolf's pure-Lua JSON encoder and decoder with LPeg acceleration. |
| [**`lpeg`**](packages/l/lpeg/xmake.lua) | Pattern-Matching for Lua using Parsing Expression Grammars (PEGs). |
| [**`lpeg-patterns`**](packages/l/lpeg-patterns/xmake.lua) | Collection of useful LPeg patterns (URI, HTTP, IPv4, IPv6, email, etc.). |
| [**`lpeglabel`**](packages/l/lpeglabel/xmake.lua) | Parsing Expression Grammars with labeled failures for syntax error reporting. |
| [**`lrexlib-pcre2`**](packages/l/lrexlib-pcre2/xmake.lua) | High-performance PCRE2 regular expression library bindings for Lua. |
| [**`lyaml`**](packages/l/lyaml/xmake.lua) | LibYAML binding for Lua. |
| [**`libyaml`**](packages/l/libyaml/xmake.lua) | Fast C library for parsing and emitting YAML. |
| [**`luaexpat`**](packages/l/luaexpat/xmake.lua) | XML parsing library based on the Expat stream parser for Lua. |
| [**`expadom`**](packages/e/expadom/xmake.lua) | Expat-based XML DOM Level 2 parser and tree representation for Lua. |
| [**`markdown`**](packages/m/markdown/xmake.lua) | Pure-Lua implementation of the Markdown text-to-HTML markup system. |
| [**`inifile`**](packages/i/inifile/xmake.lua) | Complete, simple INI configuration parser and writer for Lua. |
| [**`serpent`**](packages/s/serpent/xmake.lua) | Lua table serializer, deserializer, and human-readable pretty printer. |
| [**`cosmo`**](packages/c/cosmo/xmake.lua) | Safe, expressive template engine for Lua. |
| [**`etlua`**](packages/e/etlua/xmake.lua) | Embedded Lua templates (ERB/EJS style) compiled to efficient Lua code. |

### Networking, Web & Services

#### Core Networking, Sockets & TLS

| Package | Description |
| :--- | :--- |
| [**`luasocket`**](packages/l/luasocket/xmake.lua) | Foundational networking support (TCP, UDP, HTTP, FTP, SMTP, DNS, MIME) for Lua. |
| [**`luasec`**](packages/l/luasec/xmake.lua) | OpenSSL binding providing TLS/SSL secure communication over LuaSocket. |
| [**`luaossl`**](packages/l/luaossl/xmake.lua) | Comprehensive, modern OpenSSL binding for Lua (crypto, x509, bignum, ssl). |
| [**`copas`**](packages/c/copas/xmake.lua) | Coroutine Oriented Portable Asynchronous Services and dispatcher for LuaSocket. |
| [**`lua-mimetypes`**](packages/l/lua-mimetypes/xmake.lua) | Fast MIME type lookup table for file extensions and media types. |
| [**`lua-psl`**](packages/l/lua-psl/xmake.lua) | Lua binding to libpsl for Public Suffix List lookups and cookie domain validation. |

#### Web Frameworks & Server Interfaces (WSAPI & Kepler)

| Package | Description |
| :--- | :--- |
| [**`lua-http`**](packages/l/lua-http/xmake.lua) | Performant, modern HTTP/1.1 and HTTP/2 client/server and WebSocket library for Lua. |
| [**`lapis`**](packages/l/lapis/xmake.lua) | High-performance full-stack web framework for MoonScript and Lua (OpenResty / Server). |
| [**`wsapi`**](packages/w/wsapi/xmake.lua) | WSAPI abstracts the web server from Lua web applications (WSGI/Rack equivalent). |
| [**`cgilua`**](packages/c/cgilua/xmake.lua) | Tool for creating dynamic web pages and processing web forms across CGI/FastCGI. |
| [**`orbit`**](packages/o/orbit/xmake.lua) 🗄️ | MVC web development framework built upon WSAPI for the Kepler platform (legacy WSAPI). |
| [**`lua-lace`**](packages/l/lua-lace/xmake.lua) | Access control and ACL evaluation engine modelled on Squid syntax. |

#### OpenResty & NGINX Ecosystem

| Package | Description |
| :--- | :--- |
| [**`lua-radix-router`**](packages/l/lua-radix-router/xmake.lua) | Fast, lightweight API router based on radix tree for OpenResty and Lua. |
| [**`lua-resty-cookie`**](packages/l/lua-resty-cookie/xmake.lua) 🗄️ | HTTP cookie manipulation and parsing for OpenResty / ngx_lua. |
| [**`lua-resty-core`**](packages/l/lua-resty-core/xmake.lua) | FFI-based Lua API for the ngx_lua module replacing the classic C-API. |
| [**`lua-resty-dns`**](packages/l/lua-resty-dns/xmake.lua) | Nonblocking DNS resolver for the OpenResty / ngx_lua cosocket API. |
| [**`lua-resty-etcd`**](packages/l/lua-resty-etcd/xmake.lua) | Nonblocking Lua etcd v3 client driver for OpenResty. |
| [**`lua-resty-http`**](packages/l/lua-resty-http/xmake.lua) | Nonblocking Lua HTTP client cosocket driver for OpenResty. |
| [**`lua-resty-http2`**](packages/l/lua-resty-http2/xmake.lua) | HTTP/2 protocol implementation and client for OpenResty. |
| [**`lua-resty-jwt`**](packages/l/lua-resty-jwt/xmake.lua) | JSON Web Tokens (JWT) encode, decode, and verification for ngx_lua and LuaJIT. |
| [**`lua-resty-limit-traffic`**](packages/l/lua-resty-limit-traffic/xmake.lua) | Traffic shaping, rate limiting, and concurrency limiting library for OpenResty. |
| [**`lua-resty-lock`**](packages/l/lua-resty-lock/xmake.lua) | Simple nonblocking mutex lock based on shared memory dictionaries in OpenResty. |
| [**`lua-resty-lrucache`**](packages/l/lua-resty-lrucache/xmake.lua) | High-performance LRU cache based on LuaJIT FFI. |
| [**`lua-resty-maxminddb`**](packages/l/lua-resty-maxminddb/xmake.lua) | MaxMind GeoIP2 / GeoLite2 binary database reader library for OpenResty. |
| [**`lua-resty-memcached`**](packages/l/lua-resty-memcached/xmake.lua) | Nonblocking Lua memcached client driver based on the cosocket API. |
| [**`lua-resty-mysql`**](packages/l/lua-resty-mysql/xmake.lua) | Nonblocking Lua MySQL client driver for OpenResty. |
| [**`lua-resty-openidc`**](packages/l/lua-resty-openidc/xmake.lua) | OpenID Connect Relying Party and OAuth 2.0 Resource Server implementation for OpenResty. |
| [**`lua-resty-redis`**](packages/l/lua-resty-redis/xmake.lua) | Nonblocking Lua Redis client driver based on the cosocket API. |
| [**`lua-resty-requests`**](packages/l/lua-resty-requests/xmake.lua) | Human-friendly HTTP library with pooling and session management for OpenResty. |
| [**`lua-resty-session`**](packages/l/lua-resty-session/xmake.lua) | Secure and flexible HTTP session management library for OpenResty. |
| [**`lua-resty-shell`**](packages/l/lua-resty-shell/xmake.lua) | Nonblocking system shell command execution in OpenResty using sub-processes. |
| [**`lua-resty-signal`**](packages/l/lua-resty-signal/xmake.lua) | POSIX signal emitting and management library for OpenResty. |
| [**`lua-resty-socket`**](packages/l/lua-resty-socket/xmake.lua) | Transparent fallback wrapper between LuaSocket and `ngx.socket.tcp` with identical API. |
| [**`lua-resty-string`**](packages/l/lua-resty-string/xmake.lua) | String utilities and cryptographic hash functions (SHA1, SHA256, MD5) for OpenResty. |
| [**`lua-resty-upload`**](packages/l/lua-resty-upload/xmake.lua) | Streaming reading and parsing for HTTP file uploading via cosockets. |
| [**`lua-resty-websocket`**](packages/l/lua-resty-websocket/xmake.lua) | WebSocket client and server implementation for ngx_lua in OpenResty. |
| [**`lua-tablepool`**](packages/l/lua-tablepool/xmake.lua) | High-performance Lua table recycling pools for LuaJIT and OpenResty. |

### Databases & Storage

| Package | Description |
| :--- | :--- |
| [**`lsqlite3`**](packages/l/lsqlite3/xmake.lua) | Complete binding for Lua to the SQLite3 database library with full API support. |
| [**`luasql`**](packages/l/luasql/xmake.lua) | Unified database connectivity for Lua supporting SQLite3, PostgreSQL, MySQL, and ODBC. |
| [**`pgmoon`**](packages/p/pgmoon/xmake.lua) | Pure-Lua PostgreSQL driver with SSL support for OpenResty, cqueues, and LuaSocket. |
| [**`redis-lua`**](packages/r/redis-lua/xmake.lua) | Fast, pure-Lua client library for the Redis in-memory storage engine. |

### System, Hardware & Native Extensions

| Package | Description |
| :--- | :--- |
| [**`luaposix`**](packages/l/luaposix/xmake.lua) | Comprehensive POSIX binding for Lua (unistd, dirent, fcntl, signal, poll, etc.). |
| [**`sol2`**](packages/s/sol2/xmake.lua) | High-performance C++17/C++20 Lua binding and embedding library with ergonomic API. |
| [**`luafilesystem`**](packages/l/luafilesystem/xmake.lua) | File system directory traversal, file attributes, and permissions for Lua. |
| [**`luasystem`**](packages/l/luasystem/xmake.lua) | Platform-independent system calls, sleep, high-resolution timers, and terminal state. |
| [**`cffi-lua`**](packages/c/cffi-lua/xmake.lua) | Portable C Foreign Function Interface (FFI) for Lua 5.1+ based on libffi. |
| [**`solo`**](packages/s/solo/xmake.lua) | Physical I/O, system foundations, and low-level hardware abstractions for embedded targets. |
| [**`luv`**](packages/l/luv/xmake.lua) | Bare libuv bindings providing asynchronous I/O and event loop integration for Lua. |
| [**`lua-bz2`**](packages/l/lua-bz2/xmake.lua) | Lua binding to Julian Seward's libbzip2 compression library. |
| [**`luazip`**](packages/l/luazip/xmake.lua) | Lua extension library used to inspect and read files stored inside ZIP archives. |
| [**`lua-iconv`**](packages/l/lua-iconv/xmake.lua) | Lua binding to POSIX `iconv` for character encoding conversion. |
| [**`lualogging`**](packages/l/lualogging/xmake.lua) | Unified logging API with multiple appenders (file, rolling, console, email, socket). |
| [**`luasyslog`**](packages/l/luasyslog/xmake.lua) | Syslog logging addon for LuaLogging and standalone syslog access. |
| [**`monocypher`**](packages/m/monocypher/xmake.lua) | Small, easy-to-use, easy-to-audit cryptographic library (Blake2b, Poly1305, Ed25519). |
| [**`openal-soft`**](packages/o/openal-soft/xmake.lua) | Software implementation of the OpenAL 3D audio API for multimedia and games. |

### Testing, Quality & Tooling

| Package | Description |
| :--- | :--- |
| [**`mobdebug`**](packages/m/mobdebug/xmake.lua) | Remote debugger and profiler for Lua, LuaJIT, and OpenResty. |
| [**`busted`**](packages/b/busted/xmake.lua) | Elegant, extensible Behavior-Driven Development (BDD) testing framework for Lua. |
| [**`luassert`**](packages/l/luassert/xmake.lua) | Assertion, matcher, and test spy library for Lua. |
| [**`say`**](packages/s/say/xmake.lua) | Key/value string store for internationalization (i18n) and assertion failure messages. |
| [**`greatest`**](packages/g/greatest/xmake.lua) | Lightweight, single-header C unit testing system with zero external dependencies. |
| [**`luacheck`**](packages/l/luacheck/xmake.lua) | Fast static analyzer and linter for Lua code detecting undefined variables and shadows. |
| [**`luacov`**](packages/l/luacov/xmake.lua) | Line and statement code coverage analysis tool for Lua scripts. |
| [**`cluacov`**](packages/c/cluacov/xmake.lua) | C acceleration extension for LuaCov improving coverage analysis performance. |
| [**`luacov-reporter-lcov`**](packages/l/luacov-reporter-lcov/xmake.lua) | Coverage reporter exporting LuaCov results into standard LCOV tracefile format. |
| [**`ldoc`**](packages/l/ldoc/xmake.lua) | Modern documentation generation tool for Lua codebases compatible with LuaDoc. |

### CLI, Terminal & Text UI

| Package | Description |
| :--- | :--- |
| [**`argparse`**](packages/a/argparse/xmake.lua) | Feature-rich command-line argument parser with subcommands, flags, and help generation. |
| [**`lua-cliargs`**](packages/l/lua-cliargs/xmake.lua) | Command-line argument parsing module supporting typed arguments and short/long options. |
| [**`ansicolors`**](packages/a/ansicolors/xmake.lua) | ANSI terminal colors and text styling manipulation for Lua. |
| [**`lua-term`**](packages/l/lua-term/xmake.lua) | Terminal manipulation library (cursor movement, clear screen, colors) for Lua. |
| [**`terminal.lua`**](packages/t/terminal.lua/xmake.lua) | Cross-platform terminal library for Lua (Windows Virtual Terminal / Unix VT100). |

### Data Structures, Concurrency & Utilities

| Package | Description |
| :--- | :--- |
| [**`penlight`**](packages/p/penlight/xmake.lua) | Comprehensive pure-Lua utility library set inspired by Python's standard libraries. |
| [**`middleclass`**](packages/m/middleclass/xmake.lua) | Simple, clean object-oriented programming (OOP) library with inheritance for Lua. |
| [**`moses`**](packages/m/moses/xmake.lua) | Functional programming utility library for Lua (analogous to Underscore.js / Lodash). |
| [**`inspect`**](packages/i/inspect/xmake.lua) | Human-readable representation, debugging, and deep inspection of Lua tables. |
| [**`date`**](packages/d/date/xmake.lua) | Comprehensive date and time calculation, formatting, and parsing module for Lua 5.x. |
| [**`basexx`**](packages/b/basexx/xmake.lua) | Base2, base16, base32, base64, and base85 encoding/decoding library for Lua. |
| [**`md5`**](packages/m/md5/xmake.lua) | Cryptographic facilities for Lua: MD5 hash function and DES56 encryption. |
| [**`binaryheap`**](packages/b/binaryheap/xmake.lua) | Binary Heap priority queue implementation in pure Lua. |
| [**`fifo.lua`**](packages/f/fifo.lua/xmake.lua) | Fast, pure-Lua first-in-first-out (FIFO) queue data structure implementation. |
| [**`timerwheel`**](packages/t/timerwheel/xmake.lua) | High-performance, constant-time timer wheel implementation in pure Lua. |
| [**`mediator-lua`**](packages/m/mediator-lua/xmake.lua) | Mediator pattern implementation for event-driven decoupled systems in Lua. |
| [**`push`**](packages/p/push/xmake.lua) | Observable properties and reactive state binding implementation for Lua. |
| [**`loadkit`**](packages/l/loadkit/xmake.lua) | Load arbitrary resources and non-code files within the Lua package search path. |
| [**`cqueues`**](packages/c/cqueues/xmake.lua) | Embeddable, stackable coroutine event loop and asynchronous I/O engine for POSIX systems. |
| [**`lanes`**](packages/l/lanes/xmake.lua) | Multithreading and parallel execution library for Lua with isolated states and inter-thread channels. |
| [**`lumen`**](packages/l/lumen/xmake.lua) | Simple concurrent task scheduling and cooperative multitasking environment for Lua. |
| [**`coxpcall`**](packages/c/coxpcall/xmake.lua) | Coroutine-safe `pcall` and `xpcall` implementations across Lua versions. |
| [**`lua-typeof`**](packages/l/lua-typeof/xmake.lua) | Fast, comprehensive type checking and schema validation library for Lua. |
| [**`luautf8`**](packages/l/luautf8/xmake.lua) | UTF-8 support library for Lua 5.1/LuaJIT matching Lua 5.3+ standard `utf8` functions. |

---

## Usage & Architecture Examples

### 1. Installing & Using the Recudo Addon

The **Recudo Addon** provides unified project compilation, transpilation rules, runtime selection, and toolchain management:

```bash
# Install the addon directly from this repository:
xmake addon --install recudo

# Or install from GitHub:
xmake addon --install github:projectum-lunare/recudo
```

To use it in your project's `xmake.lua`:

```lua
add_repositories("projectum-lunare https://github.com/projectum-lunare/xmake-repo.git")
add_requires("recudo master", {kind = "addon"})

includes("@addon/recudo/recudo.lua")
```

---

### 2. Multi-Runtime Selection (PUC-Lua vs LuaJIT vs OpenResty)

Packages orchestrated via Recudo support multi-runtime selection with isolated `buildhash` cache keys, allowing seamless switching between engines without ABI collisions:

```bash
# Install package compiled against default PUC-Rio Lua:
xrepo install luasocket

# Install package compiled against LuaJIT 2.1:
xrepo install -f "runtime='luajit'" luasocket

# Install package compiled against OpenResty LuaJIT:
xrepo install -f "runtime='openresty-luajit'" luasocket
```

Declare runtime requirements directly in your `xmake.lua`:

```lua
add_requires("luasocket", {configs = {runtime = "luajit"}})
add_requires("lua-cjson", {configs = {runtime = "openresty-luajit"}})
```

---

### 3. Requiring Dialects & Transpilers in `xmake.lua`

Recudo provides declarative build rules for transpiled dialects:

```lua
add_rules("mode.debug", "mode.release")

add_requires("recudo master", {kind = "addon"})
add_requires("pluto", "tl", "typescript-to-lua", "erde", "pallene", "nelua")

includes("@addon/recudo/recudo.lua")

-- Pluto Dialect Application
target("pluto_app")
    add_rules("recudo.lua.app", "recudo.lang.pluto")
    add_files("src/*.pluto")
    add_packages("pluto")

-- Typed Lua with Teal
target("teal_module")
    add_rules("recudo.lua.module", "recudo.lang.teal")
    add_files("src/*.tl")
    add_packages("tl")

-- TypeScript to Lua
target("ts_app")
    add_rules("recudo.lua.app", "recudo.lang.typescript")
    add_files("src/*.ts")
    add_packages("typescript-to-lua")

-- Nelua Systems Application
target("systems_app")
    add_rules("recudo.lang.nelua")
    add_files("src/*.nelua")
    add_packages("nelua")
```

---

### 4. Multi-Backend Haxe Compilation (Native C++ & Lua)

Compile native C++ binaries using Haxe and `hxcpp`, or transpile Haxe source code directly to portable Lua:

```lua
add_requires("haxe", "hxcpp")
add_requires("recudo master", {kind = "addon"})
includes("@addon/recudo/recudo.lua")

-- Compile native C++ binary via Haxe and hxcpp
target("haxe_native")
    set_kind("binary")
    add_rules("recudo.lang.haxe")
    add_files("src/NativeMain.hx")
    set_values("recudo.lang.haxe.backend", "cpp")
    set_values("recudo.lang.haxe.main", "NativeMain")
    add_packages("haxe", "hxcpp")

-- Transpile Haxe directly to portable Lua
target("haxe_lua")
    add_rules("recudo.lua.app", "recudo.lang.haxe")
    add_files("src/LuaMain.hx")
    set_values("recudo.lang.haxe.main", "LuaMain")
    add_packages("haxe")
```

---

### 5. Building Standalone Games with LÖVE & Libraries

Create standalone, distributable games using the official LÖVE engine and curated libraries:

```lua
add_rules("mode.debug", "mode.release")

add_requires("recudo master", {kind = "addon"})
add_requires("love")
add_requires("anim8", "bump", "hump", "flux", "tween", "lume")

includes("@addon/recudo/recudo.lua")

target("mygame")
    add_rules("recudo.engine.love")
    add_packages("love", "anim8", "bump", "hump", "flux", "tween", "lume")
    add_files("src/main.lua")
```

* **Development mode (`xmake run`)**: Runs your game interpreted directly from source with automatic search paths.
* **Release mode (`xmake -m release`)**: Fuses the executable with all game assets and bundled Lua modules into a single standalone binary.

---

### 6. Native C & C++ Libraries in `xmake.lua`

Requiring single-header test frameworks or compiled native extensions:

```lua
add_requires("greatest", "lpeg", "monocypher")

target("test_runner")
    set_kind("binary")
    add_files("tests/*.c")
    add_packages("greatest", "lpeg", "monocypher")
```

---

### 7. Embedded Lua & Retro Platform Configurations

PUC-Rio Lua supports embedded and retro patches for restricted environments (C89 compliance, 32-bit integers, parser disabling):

```lua
-- Target embedded or retro architectures
add_requires("lua", {
    configs = {
        c89 = true,         -- Strict ANSI C89 / ISO C90 compatibility
        ["32bits"] = true,  -- Force 32-bit integer/float size
        no_parser = false   -- Retain or strip the Lua compiler
    }
})

target("embedded_firmware")
    set_kind("binary")
    add_files("src/*.c")
    add_packages("lua")
```

---

### 8. Auditing Recipes with Package Linter

Ensure all package manifests comply with repository metadata, checksum formats, `on_test` hooks, and Recudo conventions:

```bash
# Validate all packages across the entire repository:
xmake l scripts/check_packages.lua

# Validate a specific package recipe:
xmake l scripts/check_packages.lua haxe
xmake l scripts/check_packages.lua pluto
```

---

## License

This repository is licensed under the [Mozilla Public License Version 2.0 (MPL-2.0)](LICENSE).
Individual package recipes build software subject to their respective upstream licenses.
