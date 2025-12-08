#!/usr/bin/env bats

load flash

@test "in quiet mode, two different match-counts in a line are flashed" {
    run -0 extractMatches --quiet --unbuffered --to flash --match-count fo+ --global --match-count '\<\w{4}\>' --global <<-'EOF'
Just some sexy text.
This has foo, foo and foofoo in it.
All simple text.
More foo here.
Seriously, why?
EOF
    assert_output "${R}Just (1)${N}Just${R}some (1)${N}some${R}sexy (1)${N}sexy${R}text (1)${N}text${R}This (1)${N}This${FOO_C1}${FOO_C2}${FOO_C3}${FOO_C4}${R}text (2)${N}text${R}More (1)${N}More${FOO_C5}${R}here (1)${N}here"
}
