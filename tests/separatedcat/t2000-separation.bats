#!/usr/bin/env bats

load fixture

@test "default separation with an empty line" {
    runWithEOF -0 separatedcat -- "${BATS_TEST_DIRNAME}/input"/id_*.conf
    output="${output%EOF}" assert_output - <<'EOF'
# My old (DSA) work identity
IdentityFile ~/.ssh/id_dsa

IdentityFile ~/.ssh/id_ed25519
IdentityFile ~/.ssh/id_ed25520

IdentityFile ~/.ssh/id_rsa

# No work
# any longer
EOF
}

@test "custom line-based separation" {
    runWithEOF -0 separatedcat --separator $'\n---\n' -- "${BATS_TEST_DIRNAME}/input"/id_*.conf
    output="${output%EOF}" assert_output - <<'EOF'
# My old (DSA) work identity
IdentityFile ~/.ssh/id_dsa
---
IdentityFile ~/.ssh/id_ed25519
IdentityFile ~/.ssh/id_ed25520
---
IdentityFile ~/.ssh/id_rsa
---
# No work
# any longer
EOF
}

@test "custom newline separation works like cat" {
    run -0 separatedcat --separator $'\n' -- "${BATS_TEST_DIRNAME}/input"/id_*.conf
    assert_output "$(cat -- "${BATS_TEST_DIRNAME}/input"/id_*.conf)"
}

@test "custom inline separation" {
    runWithEOF -0 separatedcat --separator ' <-> ' -- "${BATS_TEST_DIRNAME}/input"/id_*.conf
    output="${output%EOF}" assert_output - <<'EOF'
# My old (DSA) work identity
IdentityFile ~/.ssh/id_dsa <-> IdentityFile ~/.ssh/id_ed25519
IdentityFile ~/.ssh/id_ed25520 <-> IdentityFile ~/.ssh/id_rsa <-> # No work
# any longer
EOF
}

@test "no separation" {
    runWithEOF -0 separatedcat --separator '' -- "${BATS_TEST_DIRNAME}/input"/id_*.conf
    output="${output%EOF}" assert_output - <<'EOF'
# My old (DSA) work identity
IdentityFile ~/.ssh/id_dsaIdentityFile ~/.ssh/id_ed25519
IdentityFile ~/.ssh/id_ed25520IdentityFile ~/.ssh/id_rsa# No work
# any longer
EOF
}
