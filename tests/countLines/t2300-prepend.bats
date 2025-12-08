#!/usr/bin/env bats

load fixture

@test "prepend count" {
    runWithCannedInput -0 countLines --prepend thing
    assert_output - <<'EOF'
(thing 1) foo
(thing 2) bar
(thing 3) baz
(thing 4) hihi
(thing 5) 
(thing 6) something
(thing 7) is
(thing 8) wrong
(thing 9) here
(thing 10) 
(thing 11) nothing
(thing 12) for
(thing 13) me
EOF
}
