#!/usr/bin/env bats

load fixture

@test "including files with zero length" {
    runWithEOF -0 separatedcat --separator $'\n---\n' --truncate-empty-lines -- "${BATS_TEST_DIRNAME}/zero-length"/*
    output="${output%EOF}" assert_output '# My old (DSA) work identity
IdentityFile ~/.ssh/id_dsa
---
# two leading empty lines
IdentityFile ~/.ssh/id_ed25519
IdentityFile ~/.ssh/id_ed25520
---
---
# three trailing empty lines
IdentityFile ~/.ssh/id_rsa
---
# both one leading and trailing line
IdentityFile ~/.ssh/id_work
'
}
