#!/usr/bin/env bats

load fixture

@test "count all input" {
    runWithCannedInput countLines
    [ $status -eq 0 ]
    [ "$output" = "(1) foo
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
(13) me" ]
}
