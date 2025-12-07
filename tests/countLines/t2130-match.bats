#!/usr/bin/env bats

load fixture

@test "count matching non-empty lines" {
    runWithCannedInput -0 countLines --match .
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

@test "count matching three- and four-letter lines" {
    runWithCannedInput -0 countLines --match '^...$' --match '^....$'
    assert_output - <<'EOF'
(1) foo
(2) bar
(3) baz
(4) hihi

something
is
wrong
(5) here

nothing
(6) for
me
EOF
}
