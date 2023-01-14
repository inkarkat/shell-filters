#!/usr/bin/env bats

load fixture

@test "append count" {
    runWithCannedInput countLines --append thing
    [ $status -eq 0 ]
    [ "$output" = "foo (thing 1)
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
me (thing 13)" ]
}
