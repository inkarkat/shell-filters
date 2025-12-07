#!/usr/bin/env bats

load fixture

@test "summarize" {
    runWithCannedInput -0 countLines --summarize stuff
    assert_output - <<'EOF'
(1) foo
(2) bar
(3) baz
(4) hihi
(5) 
(6) something
(7) is
(8) wrong
(9) here
(10) 
(11) nothing
(12) for
(13) me
(13 stuffs in total)
EOF
}

@test "summarize singular" {
    runWithInput -0 foo countLines --summarize entry,entries
    assert_output - <<'EOF'
(1) foo
(1 entry in total)
EOF
}

@test "summarize plural" {
    runWithInput -0 $'foo\nbar' countLines --summarize entry,entries
    assert_output - <<'EOF'
(1) foo
(2) bar
(2 entries in total)
EOF
}

@test "summarize nothing" {
    runWithInput -0 '' countLines --summarize entry,entries
    assert_output '(0 entries in total)'
}

@test "summary only" {
    runWithCannedInput -0 countLines --summarize stuff --summary-only
    assert_output - <<'EOF'
foo
bar
baz
hihi

something
is
wrong
here

nothing
for
me
(13 stuffs in total)
EOF
}
