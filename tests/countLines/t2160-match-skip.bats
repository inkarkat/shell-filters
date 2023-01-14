#!/usr/bin/env bats

load fixture

@test "count matching non-empty lines but skipping lines with three letters" {
    runWithCannedInput countLines --match . --skip '^...$'
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
