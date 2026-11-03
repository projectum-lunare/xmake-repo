-- Projectum Lunare Xmake Repository - monocypher Package
-- Category: System, Hardware & Native Bindings
-- A small, easy-to-use, easy-to-audit crypto library (raw C library - the Lua binding ships as monocypher.lua)
-- Supported Platforms: Linux, macOS, BSD, Windows, WASM/WASI (portable C99)

package("monocypher")
    set_homepage("https://monocypher.org")
    set_description("A small, easy-to-use, easy-to-audit crypto library.")
    set_license("BSD-2-Clause or CC0-1.0")

    add_urls("https://github.com/LoupVaillant/Monocypher/releases/download/$(version)/monocypher-$(version).tar.gz")
    add_urls("https://github.com/LoupVaillant/Monocypher.git")

    add_versions("4.0.3", "8cc9bc341a66249016db9bd70e9142d8d0aef9945973744b1ac05dbc55d8ee66")
    add_versions("4.0.2", "38d07179738c0c90677dba3ceb7a7b8496bcfea758ba1a53e803fed30ae0879c")

    -- Upstream's default build folds the optional module (SHA-512 and the
    -- Ed25519 compatibility wrappers) into libmonocypher; mirror that here.
    add_configs("optional", {
        description = "Include the optional module (SHA-512 and Ed25519 compatibility wrappers).",
        default = true,
        type = "boolean"
    })

    on_install(function (package)
        local optional = package:config("optional")
        local nested = [[
            add_rules("mode.release", "mode.debug")

            target("monocypher")
                set_kind("$(kind)")
                add_includedirs("src")
                add_headerfiles("src/monocypher.h")
                add_files("src/monocypher.c")
        ]]
        if optional then
            nested = nested .. [[
                add_includedirs("src/optional")
                add_headerfiles("src/optional/monocypher-ed25519.h")
                add_files("src/optional/monocypher-ed25519.c")
        ]]
        end
        io.writefile("xmake.lua", nested)
        import("package.tools.xmake").install(package)
    end)

    on_test(function (package)
        -- Known-answer tests generated with an independent implementation
        -- (Python hashlib), plus an AEAD round-trip. A snippet that only
        -- compiles cannot catch a broken build - these must run and be able
        -- to fail (tryrun makes any mismatch abort the installation).
        local includes = {"string.h", "monocypher.h"}
        if package:config("optional") then
            table.insert(includes, "monocypher-ed25519.h")
        end
        local test_body = [[
            unsigned char hash[64];
            static const unsigned char want_blake2b_abc[64] = {
                0xba, 0x80, 0xa5, 0x3f, 0x98, 0x1c, 0x4d, 0x0d,
                0x6a, 0x27, 0x97, 0xb6, 0x9f, 0x12, 0xf6, 0xe9,
                0x4c, 0x21, 0x2f, 0x14, 0x68, 0x5a, 0xc4, 0xb7,
                0x4b, 0x12, 0xbb, 0x6f, 0xdb, 0xff, 0xa2, 0xd1,
                0x7d, 0x87, 0xc5, 0x39, 0x2a, 0xab, 0x79, 0x2d,
                0xc2, 0x52, 0xd5, 0xde, 0x45, 0x33, 0xcc, 0x95,
                0x18, 0xd3, 0x8a, 0xa8, 0xdb, 0xf1, 0x92, 0x5a,
                0xb9, 0x23, 0x86, 0xed, 0xd4, 0x00, 0x99, 0x23
            };
            crypto_blake2b(hash, sizeof(hash), (const unsigned char *)"abc", 3);
            if (memcmp(hash, want_blake2b_abc, sizeof(want_blake2b_abc)) != 0) {
                return 1;
            }
            {
                unsigned char key[32], nonce[24], mac[16], cipher[5], plain[5] = {1, 2, 3, 4, 5}, roundtrip[5];
                memset(key, 0xa5, sizeof(key));
                memset(nonce, 0x5a, sizeof(nonce));
                crypto_aead_lock(cipher, mac, key, nonce, NULL, 0, plain, sizeof(plain));
                if (crypto_aead_unlock(roundtrip, mac, key, nonce, NULL, 0, cipher, sizeof(cipher)) != 0 ||
                    memcmp(roundtrip, plain, sizeof(plain)) != 0) {
                    return 1;
                }
            }
        ]]
        if package:config("optional") then
            test_body = test_body .. [[
            static const unsigned char want_sha512_abc[64] = {
                0xdd, 0xaf, 0x35, 0xa1, 0x93, 0x61, 0x7a, 0xba,
                0xcc, 0x41, 0x73, 0x49, 0xae, 0x20, 0x41, 0x31,
                0x12, 0xe6, 0xfa, 0x4e, 0x89, 0xa9, 0x7e, 0xa2,
                0x0a, 0x9e, 0xee, 0xe6, 0x4b, 0x55, 0xd3, 0x9a,
                0x21, 0x92, 0x99, 0x2a, 0x27, 0x4f, 0xc1, 0xa8,
                0x36, 0xba, 0x3c, 0x23, 0xa3, 0xfe, 0xeb, 0xbd,
                0x45, 0x4d, 0x44, 0x23, 0x64, 0x3c, 0xe8, 0x0e,
                0x2a, 0x9a, 0xc9, 0x4f, 0xa5, 0x4c, 0xa4, 0x9f
            };
            crypto_sha512(hash, (const unsigned char *)"abc", 3);
            if (memcmp(hash, want_sha512_abc, sizeof(want_sha512_abc)) != 0) {
                return 1;
            }
            ]]
        end
        if package:is_cross() then
            assert(package:has_cincludes("monocypher.h"))
            if package:config("optional") then
                assert(package:has_cincludes("monocypher-ed25519.h"))
            end
        else
            assert(package:check_csnippets({test = test_body}, {includes = includes, tryrun = true}))
        end
    end)
