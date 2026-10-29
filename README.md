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

| Package | Kind | Description | Version |
| :--- | :--- | :--- | :--- |
| [**`forge`**](packages/f/forge/xmake.lua) | `addon` | Unified build, toolchain and cross-compilation engine for Xmake | `master`, `v0.1.0` |
| [**`greatest`**](packages/g/greatest/xmake.lua) | `library` | Lightweight C89 unit testing framework in one header file | `release`, `v1.5.0` |
| [**`lpeg`**](packages/l/lpeg/xmake.lua) | `library` | Parsing Expression Grammars (PEGs) for Lua | `v1.1.0`, `v1.0.2` |
| [**`lua`**](packages/l/lua/xmake.lua) | `library` | Embeddable scripting language with retro-computing, embedded and C89 patches | `v5.5.1`, `v5.4.8`, ... |

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
