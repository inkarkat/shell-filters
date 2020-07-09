#!/usr/bin/env bats

input="2020-07-04T16:07:23 foo
2020-07-04T16:07:23 foo2
2020-07-04T16:07:23 foo3
2020-07-04T16:07:24 bar
2020-07-04T16:07:28 baz
2020-07-04T16:07:28 baz2"

@test "identical ISO 8601 timestamps as first field are condensed to the first occurrence" {
    run timestampTally <<<"$input"

    [ $status -eq 0 ]
    [ "$output" = "0 foo
0 bar
0 baz" ]
}

@test "identical ISO 8601 timestamps as first field explicitly specified are condensed to the first occurrence" {
    run timestampTally --timestamp-field 1 <<<"$input"

    [ $status -eq 0 ]
    [ "$output" = "0 foo
0 bar
0 baz" ]
}

@test "identical RFC 3339 timestamps as first field are condensed to the first occurrence" {
    run timestampTally <<<"${input//T/ }"

    [ $status -eq 0 ]
    [ "$output" = "0 foo
0 bar
0 baz" ]
}

@test "identical RFC 3339 timestamps as first two fields explicitly specified are condensed to the first occurrence with the second field kept empty" {
    run timestampTally --timestamp-field 1-2 <<<"${input//T/ }"

    [ $status -eq 0 ]
    [ "$output" = "0  foo
0  bar
0  baz" ]
}

@test "identical RFC 3339 timestamps as first two fields explicitly specified with open range are condensed to the first occurrence with the second field kept empty" {
    run timestampTally --timestamp-field -2 <<<"${input//T/ }"

    [ $status -eq 0 ]
    [ "$output" = "0  foo
0  bar
0  baz" ]
}

@test "identical RFC 3339 timestamps as fields 1 and 3 explicitly specified are forbidden because they are non-sequential" {
    run timestampTally --timestamp-field 1,3 <<<"${input//T/ what }"

    [ $status -eq 2 ]
    [ "$output" = "ERROR: Timestamp field 3 does not follow 1." ]
}
