#!/usr/bin/env bats

@test "discontinuous epochs as first field are printed as-is" {
    input="1593871643 foo
1593871644 bar
1593871648 baz"

    run timestampTally <<<"$input"

    [ $status -eq 0 ]
    [ "$output" = "$input" ]
}

@test "discontinuous epochs as last (third) field are printed as-is" {
    input="foo is 1593871643
bar has 1593871644
baz was 1593871648"

    run timestampTally <<<"$input"

    [ $status -eq 0 ]
    [ "$output" = "$input" ]
}
