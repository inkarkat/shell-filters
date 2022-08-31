#!/usr/bin/env bats

load fixture

@test "count matching non-empty lines" {
    runWithCannedInput countLines --match .
    [ $status -eq 0 ]
    [ "$output" = "(1) foo
(2) bar
(3) baz
(4) hihi

(5) something
(6) is
(7) wrong
(8) here

(9) nothing
(10) for
(11) me" ]
}

@test "count matching three- and four-letter lines" {
    runWithCannedInput countLines --match '^...$' --match '^....$'
    [ $status -eq 0 ]
    [ "$output" = "(1) foo
(2) bar
(3) baz
(4) hihi

something
is
wrong
(5) here

nothing
(6) for
me" ]
}
