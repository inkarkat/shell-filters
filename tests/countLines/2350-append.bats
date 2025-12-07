#!/usr/bin/env bats

load fixture

@test "append count" {
    runWithCannedInput -0 countLines --append thing
    assert_output - <<'EOF'
foo (thing 1)
bar (thing 2)
baz (thing 3)
hihi (thing 4)
 (thing 5)
something (thing 6)
is (thing 7)
wrong (thing 8)
here (thing 9)
 (thing 10)
nothing (thing 11)
for (thing 12)
me (thing 13)
EOF
}
