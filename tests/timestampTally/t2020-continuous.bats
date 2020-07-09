#!/usr/bin/env bats

input="1593871643 foo
1593871643 foo2
1593871643 foo3
1593871644 bar
1593871648 baz
1593871648 baz2"

@test "identical epochs as first field are condensed to the first occurrence" {
    run timestampTally <<<"$input"

    [ $status -eq 0 ]
    [ "$output" = "0 foo
0 bar
0 baz" ]
}

@test "identical epochs as first field explicitly specified are condensed to the first occurrence" {
    run timestampTally --timestamp-field 1 <<<"$input"

    [ $status -eq 0 ]
    [ "$output" = "0 foo
0 bar
0 baz" ]
}
