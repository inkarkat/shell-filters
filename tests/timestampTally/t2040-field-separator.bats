#!/usr/bin/env bats

input="my_1593871643_foo_la
me_1593871644_bar
you_1593871648_baz"

@test "discontinuous epochs as specified second field with underscore field separator are printed with custom field separator" {
    run timestampTally --field-separator _ --timestamp-field 2 <<<"$input"

    [ $status -eq 0 ]
    [ "$output" = "my_0_foo_la
me_0_bar
you_0_baz" ]
}

@test "discontinuous epochs as specified second field with regexp field separator are printed default space field separator" {
    run timestampTally --field-separator '[_~]' --timestamp-field 2 <<<"$input"

    [ $status -eq 0 ]
    [ "$output" = "my 0 foo la
me 0 bar
you 0 baz" ]
}
