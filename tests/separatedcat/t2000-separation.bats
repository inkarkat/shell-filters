#!/usr/bin/env bats

load fixture

@test "default separation with an empty line" {
    runWithEOF separatedcat -- "${BATS_TEST_DIRNAME}/input"/id_*.conf
    [ $status -eq 0 ]
    [ "${output%EOF}" = '# My old (DSA) work identity
IdentityFile ~/.ssh/id_dsa

IdentityFile ~/.ssh/id_ed25519
IdentityFile ~/.ssh/id_ed25520

IdentityFile ~/.ssh/id_rsa

# No work
# any longer' ]
}

@test "custom line-based separation" {
    runWithEOF separatedcat --separator $'\n---\n' -- "${BATS_TEST_DIRNAME}/input"/id_*.conf
    [ $status -eq 0 ]
    [ "${output%EOF}" = '# My old (DSA) work identity
IdentityFile ~/.ssh/id_dsa
---
IdentityFile ~/.ssh/id_ed25519
IdentityFile ~/.ssh/id_ed25520
---
IdentityFile ~/.ssh/id_rsa
---
# No work
# any longer' ]
}

@test "custom newline separation works like cat" {
    run separatedcat --separator $'\n' -- "${BATS_TEST_DIRNAME}/input"/id_*.conf
    [ $status -eq 0 ]
    [ "$output" = "$(cat -- "${BATS_TEST_DIRNAME}/input"/id_*.conf)" ]
}

@test "custom inline separation" {
    runWithEOF separatedcat --separator ' <-> ' -- "${BATS_TEST_DIRNAME}/input"/id_*.conf
    [ $status -eq 0 ]
    [ "${output%EOF}" = '# My old (DSA) work identity
IdentityFile ~/.ssh/id_dsa <-> IdentityFile ~/.ssh/id_ed25519
IdentityFile ~/.ssh/id_ed25520 <-> IdentityFile ~/.ssh/id_rsa <-> # No work
# any longer' ]
}

@test "no separation" {
    runWithEOF separatedcat --separator '' -- "${BATS_TEST_DIRNAME}/input"/id_*.conf
    [ $status -eq 0 ]
    [ "${output%EOF}" = '# My old (DSA) work identity
IdentityFile ~/.ssh/id_dsaIdentityFile ~/.ssh/id_ed25519
IdentityFile ~/.ssh/id_ed25520IdentityFile ~/.ssh/id_rsa# No work
# any longer' ]
}
