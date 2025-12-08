#!/usr/bin/env bats
shopt -qs extglob

load fixture

@test "custom line-based separation without empty lines" {
    runWithEOF -0 separatedcat --separator $'\n---\n' --truncate-empty-lines -- "${BATS_TEST_DIRNAME}/empty-lines"/id_*.conf
    output="${output%EOF}" assert_output '# My old (DSA) work identity
IdentityFile ~/.ssh/id_dsa
---
# two leading empty lines
IdentityFile ~/.ssh/id_ed25519
IdentityFile ~/.ssh/id_ed25520
---
# three trailing empty lines
IdentityFile ~/.ssh/id_rsa
---
# both one leading and trailing line
IdentityFile ~/.ssh/id_work
'
}

@test "including files with just empty lines" {
    runWithEOF -0 separatedcat --separator $'\n---\n' --truncate-empty-lines -- "${BATS_TEST_DIRNAME}/empty-lines"/id_*
    output="${output%EOF}" assert_output '# My old (DSA) work identity
IdentityFile ~/.ssh/id_dsa
---
# two leading empty lines
IdentityFile ~/.ssh/id_ed25519
IdentityFile ~/.ssh/id_ed25520
---
---
---
# three trailing empty lines
IdentityFile ~/.ssh/id_rsa
---
# both one leading and trailing line
IdentityFile ~/.ssh/id_work
'
}

@test "including files with just empty lines as first and last" {
runWithEOF -0 separatedcat --separator $'\n---\n' --truncate-empty-lines -- "${BATS_TEST_DIRNAME}/empty-lines"/!(*_extra_*)
    output="${output%EOF}" assert_output '---
# My old (DSA) work identity
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
---
'
}
