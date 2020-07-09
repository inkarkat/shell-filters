#!/usr/bin/env bats

input="1593871643 foo
1593871643 foo2
1593871643 foo3
1593871644 bar
1593871648 baz
1593871648 baz2"

@test "identical epochs as first field are condensed to the first occurrence with a custom entry duration of 3 seconds" {
    run timestampTally --entry-duration 3 <<<"$input"

    [ $status -eq 0 ]
    [ "$output" = "3 foo
3 bar
3 baz" ]
}

@test "identical epochs as first field are condensed to the first occurrence with a custom entry duration of 3 seconds and single entry duration of 10 seconds" {
    run timestampTally --single-entry-duration 10 --entry-duration 3 <<<"$input"

    [ $status -eq 0 ]
    [ "$output" = "3 foo
10 bar
3 baz" ]
}
