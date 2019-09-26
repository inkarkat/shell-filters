#!/usr/bin/env bats

@test "input with 9999 hashes is the maximum" {
    run countHashes < <( printf 'maximum  is '; printf '#%.0s' {1..9999}; printf \\n )
    [ "$output" = "maximum  is 9999" ]
}

@test "input with ten thousand resolves to overflow" {
    run countHashes < <( printf 'overflow is '; printf '#%.0s' {1..10000}; printf \\n )
    [ "$output" = "overflow is 10000+" ]
}

@test "input with more than ten thousand resolves to overflow" {
    for count in 10001 22222 100000
    do
	run countHashes < <( printf 'overflow is '; eval "printf '#%.0s' {1..$count}"; printf \\n )
	[ "$output" = "overflow is 10000+" ]
    done
}
