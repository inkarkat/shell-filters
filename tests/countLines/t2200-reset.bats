#!/usr/bin/env bats

load fixture

@test "count with reset on empty lines" {
    runWithCannedInput -0 countLines --reset-on '^$'
    assert_output - <<'EOF'
(1) foo
(2) bar
(3) baz
(4) hihi
(1) 
(2) something
(3) is
(4) wrong
(5) here
(1) 
(2) nothing
(3) for
(4) me
EOF
}

@test "count with reset on and skipping of empty lines" {
    runWithCannedInput -0 countLines --skip '^$' --reset-on '^$'
    assert_output - <<'EOF'
(1) foo
(2) bar
(3) baz
(4) hihi

(1) something
(2) is
(3) wrong
(4) here

(1) nothing
(2) for
(3) me
EOF
}
