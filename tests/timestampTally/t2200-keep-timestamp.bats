#!/usr/bin/env bats

input="1593871643 foo 1593871643
1593871643 foo2 1593871643
1593871643 foo3 1593871643
1593871644 bar 1593871644
1593871648 baz 1593871648
1593871648 baz2 1593871648"

@test "identical epochs as first field with kept start timestamp" {
    run timestampTally --keep-timestamp start <<<"$input"

    [ $status -eq 0 ]
    [ "$output" = "1593871643 0 foo 1593871643
1593871644 0 bar 1593871644
1593871648 0 baz 1593871648" ]
}

@test "identical epochs as first field explicitly specified are condensed to the first occurrence" {
    run timestampTally --timestamp-field 1 --keep-timestamp start <<<"$input"

    [ $status -eq 0 ]
    [ "$output" = "1593871643 0 foo 1593871643
1593871644 0 bar 1593871644
1593871648 0 baz 1593871648" ]
}
@test "identical epochs as third field explicitly specified are condensed to the first occurrence" {
    run timestampTally --timestamp-field 3 --keep-timestamp start <<<"$input"

    [ $status -eq 0 ]
    [ "$output" = "1593871643 foo 1593871643 0
1593871644 bar 1593871644 0
1593871648 baz 1593871648 0" ]
}
