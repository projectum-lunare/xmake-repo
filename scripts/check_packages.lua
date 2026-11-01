-- Projectum Lunare Xmake Repository - Package Linter & Validator
-- Usage: xmake l scripts/check_packages.lua [options] [package_filter]

import("core.base.option")

local total_packages = 0
local passed_packages = 0
local warning_count = 0
local error_count = 0

local function check_package(pkg_path)
    total_packages = total_packages + 1
    local repodir = path.directory(os.scriptdir())
    local relpath = path.relative(pkg_path, repodir)
    local parts = relpath:split(path.sep(), {plain = true})
    
    -- Expected structure: packages/<first_letter>/<pkg_name>/xmake.lua
    local expected_prefix = parts[2]
    local expected_name = parts[3]

    local errors = {}
    local warnings = {}

    if not expected_prefix or not expected_name or #expected_name == 0 then
        table.insert(errors, "Invalid directory layout: " .. relpath)
        return false, errors, warnings
    end

    local first_char = expected_name:sub(1, 1):lower()
    if expected_prefix ~= first_char then
        table.insert(errors, string.format("Prefix mismatch: expected '%s', got '%s'", first_char, expected_prefix))
    end

    local content = io.readfile(pkg_path)
    if not content or #content == 0 then
        table.insert(errors, "File is empty or unreadable")
        return false, errors, warnings
    end

    -- 1. Check package("<name>") declaration
    local pkg_decl = content:match('package%("(.-)"%)')
    if not pkg_decl then
        table.insert(errors, "Missing package(\"" .. expected_name .. "\") declaration")
    elseif pkg_decl ~= expected_name then
        table.insert(errors, string.format("Package name mismatch: declared '%s', directory is '%s'", pkg_decl, expected_name))
    end

    -- 2. Metadata checks
    if not content:find("set_homepage%(") then
        table.insert(warnings, "Missing set_homepage(...)")
    end
    if not content:find("set_description%(") then
        table.insert(warnings, "Missing set_description(...)")
    end
    if not content:find("set_license%(") then
        table.insert(warnings, "Missing set_license(...)")
    end

    -- 3. URLs and Versions
    if not content:find("add_urls%(") then
        table.insert(errors, "Missing add_urls(...)")
    end
    if not content:find("add_versions%(") then
        table.insert(errors, "Missing add_versions(...)")
    end

    -- Check for valid sha256 (64 hex) or git commit (40 hex) hashes
    for version, hash in content:gmatch('add_versions%("([^"]+)",%s*"([^"]+)"%)') do
        if #hash > 0 and not hash:startswith("v") and not hash:startswith("HEAD") and not hash:startswith("master") then
            if not hash:match("^%x+$") or (#hash ~= 64 and #hash ~= 40) then
                table.insert(warnings, string.format("Version '%s' hash %s does not look like a valid sha256 or git commit checksum", version, hash))
            end
        end
    end

    -- 4. Test block check
    if not content:find("on_test%(") then
        table.insert(warnings, "Missing on_test(...) validation script")
    end

    -- 5. Forge lua runtime check:
    -- If package uses forge and has lua modules, check for @addon.forge.lua.runtime
    if content:find("forge.lua.module", 1, true) and not content:find("@addon.forge.lua.runtime", 1, true) then
        table.insert(warnings, "Uses forge.lua.module without modern @addon.forge.lua.runtime setup")
    end

    if #errors > 0 then
        error_count = error_count + #errors
        return false, errors, warnings
    elseif #warnings > 0 then
        warning_count = warning_count + #warnings
        passed_packages = passed_packages + 1
        return true, errors, warnings
    else
        passed_packages = passed_packages + 1
        return true, errors, warnings
    end
end

function main(...)
    local args = {...}
    local pkg_filter = args[1]
    local repodir = path.directory(os.scriptdir())
    local packages_dir = path.join(repodir, "packages")

    cprint("${bright magenta}╔══════════════════════════════════════════════════════════════════════════════╗")
    cprint("${bright magenta}║${bright white}            Projectum Lunare Xmake Repository - Package Linter                 ${bright magenta}║")
    cprint("${bright magenta}╚══════════════════════════════════════════════════════════════════════════════╝${clear}")

    local pkg_files = os.files(path.join(packages_dir, "*", "*", "xmake.lua"))
    table.sort(pkg_files)

    for _, pkg_path in ipairs(pkg_files) do
        local pkg_name = path.basename(path.directory(pkg_path))
        if not pkg_filter or pkg_name:find(pkg_filter, 1, true) then
            local ok, errors, warnings = check_package(pkg_path)
            if not ok then
                cprint("  ${bright red}✗ ERROR${clear} ${bright white}%s${clear}", pkg_name)
                for _, err in ipairs(errors) do
                    cprint("         ${red}- %s${clear}", err)
                end
                for _, warn in ipairs(warnings) do
                    cprint("         ${yellow}- [warn] %s${clear}", warn)
                end
            elseif #warnings > 0 then
                cprint("  ${bright yellow}⚠ WARN${clear}  ${bright white}%s${clear}", pkg_name)
                for _, warn in ipairs(warnings) do
                    cprint("         ${dim}- %s${clear}", warn)
                end
            else
                cprint("  ${bright green}✓ PASS${clear}  ${bright white}%s${clear}", pkg_name)
            end
        end
    end

    cprint("\n${bright green}══════════════════════════════════════════════════════════════════════════════")
    cprint("${bright yellow}LINTER SUMMARY:${clear} Total: ${bright white}%d${clear} | Passed: ${bright green}%d${clear} | Warnings: ${bright yellow}%d${clear} | Errors: ${bright red}%d${clear}",
        total_packages,
        passed_packages,
        warning_count,
        error_count
    )
    cprint("${bright green}══════════════════════════════════════════════════════════════════════════════${clear}\n")

    if error_count > 0 then
        os.exit(1)
    end
end
