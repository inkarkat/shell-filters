#!/usr/bin/env bats

input="1593871643 foo
1593871643 foo2
1593871643 foo3
1593871644 bar
1593871648 baz
1593871648 baz2"

@test "identical epochs as first field are condensed to the first occurrence with a custom single entry duration of 10 seconds" {
    run timestampTally --single-entry-duration 10 <<<"$input"

    [ $status -eq 0 ]
    [ "$output" = "10 foo
10 bar
10 baz" ]
}

@test "identical epochs as first field are condensed to the first occurrence with a custom single entry duration of 2 minutes" {
    run timestampTally --single-entry-duration 2m <<<"$input"

    [ $status -eq 0 ]
    [ "$output" = "120 foo
120 bar
120 baz" ]
}
