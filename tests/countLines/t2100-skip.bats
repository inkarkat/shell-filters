#!/usr/bin/env bats

load fixture

@test "count skipping empty lines" {
    runWithCannedInput -0 countLines --skip '^$'
    assert_output - <<'EOF'
(1) foo
(2) bar
(3) baz
(4) hihi

(5) something
(6) is
(7) wrong
(8) here

(9) nothing
(10) for
(11) me
EOF
}

@test "count skipping of empty and three-letter lines" {
    runWithCannedInput -0 countLines --skip '^$' --skip '^...$'
    assert_output - <<'EOF'
foo
bar
baz
(1) hihi

(2) something
(3) is
(4) wrong
(5) here

(6) nothing
for
(7) me
EOF
}
