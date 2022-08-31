#!/usr/bin/env bats

load fixture

@test "count skipping empty lines" {
    runWithCannedInput countLines --skip '^$'
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

@test "count skipping of empty and three-letter lines" {
    runWithCannedInput countLines --skip '^$' --skip '^...$'
    [ $status -eq 0 ]
    [ "$output" = "foo
bar
baz
(1) hihi

(2) something
(3) is
(4) wrong
(5) here

(6) nothing
for
(7) me" ]
}
