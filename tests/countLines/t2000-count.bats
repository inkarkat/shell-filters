#!/usr/bin/env bats

load fixture

@test "count all input" {
    runWithCannedInput -0 countLines
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
EOF
}
