#!/usr/bin/env bats

input="1593871643 foo 2020-07-04T16:07:23,001
1593871643 foo2 2020-07-04T16:07:23,001
1593871643 foo3 2020-07-04T16:07:23,001
1593871644 bar 2020-07-04T16:07:23,005
1593871648 baz 2020-07-04T16:07:24,100
1593871648 baz2 2020-07-04T16:07:24,100"

@test "identical epochs as first field with kept start timestamp" {
    run timestampTally --keep-timestamp start <<<"$input"

    [ $status -eq 0 ]
    [ "$output" = "1593871643 0 foo 2020-07-04T16:07:23,001
1593871644 0 bar 2020-07-04T16:07:23,005
1593871648 0 baz 2020-07-04T16:07:24,100" ]
}

@test "identical epochs as first field explicitly specified with kept start timestamp" {
    run timestampTally --timestamp-field 1 --keep-timestamp start <<<"$input"

    [ $status -eq 0 ]
    [ "$output" = "1593871643 0 foo 2020-07-04T16:07:23,001
1593871644 0 bar 2020-07-04T16:07:23,005
1593871648 0 baz 2020-07-04T16:07:24,100" ]
}
@test "identical ISO 8601 timestamps as third field explicitly specified with kept start timestamp" {
    run timestampTally --timestamp-field 3 --keep-timestamp start <<<"$input"

    [ $status -eq 0 ]
    [ "$output" = "1593871643 foo 2020-07-04T16:07:23,001 0
1593871644 bar 2020-07-04T16:07:23,005 0
1593871648 baz 2020-07-04T16:07:24,100 0" ]
}

@test "identical RFC 3339 timestamps as third and fourth fields explicitly specified with kept start timestamp" {
    run timestampTally --timestamp-field 3,4 --keep-timestamp start <<<"${input//T/ }"

    [ $status -eq 0 ]
    [ "$output" = "1593871643 foo 2020-07-04 16:07:23,001 0
1593871644 bar 2020-07-04 16:07:23,005 0
1593871648 baz 2020-07-04 16:07:24,100 0" ]
}

@test "identical epochs as first field with kept end timestamp" {
    run timestampTally --keep-timestamp end <<<"$input"

    [ $status -eq 0 ]
    [ "$output" = "1593871643 0 foo3 2020-07-04T16:07:23,001
1593871644 0 bar 2020-07-04T16:07:23,005
1593871648 0 baz2 2020-07-04T16:07:24,100" ]
}

@test "identical epochs as first field explicitly specified with kept end timestamp" {
    run timestampTally --timestamp-field 1 --keep-timestamp end <<<"$input"

    [ $status -eq 0 ]
    [ "$output" = "1593871643 0 foo3 2020-07-04T16:07:23,001
1593871644 0 bar 2020-07-04T16:07:23,005
1593871648 0 baz2 2020-07-04T16:07:24,100" ]
}
@test "identical ISO 8601 timestamps as third field explicitly specified with kept end timestamp" {
    run timestampTally --timestamp-field 3 --keep-timestamp end <<<"$input"

    [ $status -eq 0 ]
    [ "$output" = "1593871643 foo3 2020-07-04T16:07:23,001 0
1593871644 bar 2020-07-04T16:07:23,005 0
1593871648 baz2 2020-07-04T16:07:24,100 0" ]
}

@test "identical RFC 3339 timestamps as third and fourth fields explicitly specified with kept end timestamp" {
    run timestampTally --timestamp-field 3,4 --keep-timestamp end <<<"${input//T/ }"

    [ $status -eq 0 ]
    [ "$output" = "1593871643 foo3 2020-07-04 16:07:23,001 0
1593871644 bar 2020-07-04 16:07:23,005 0
1593871648 baz2 2020-07-04 16:07:24,100 0" ]
}


@test "identical epochs as first field with kept both concatenated timestamps" {
    run timestampTally --keep-timestamp both-concatenated <<<"$input"

    [ $status -eq 0 ]
    [ "$output" = "1593871643 1593871643 0 foo 2020-07-04T16:07:23,001
1593871644 1593871644 0 bar 2020-07-04T16:07:23,005
1593871648 1593871648 0 baz 2020-07-04T16:07:24,100" ]
}

@test "identical epochs as first field explicitly specified with kept both concatenated timestamps" {
    run timestampTally --timestamp-field 1 --keep-timestamp both-concatenated <<<"$input"

    [ $status -eq 0 ]
    [ "$output" = "1593871643 1593871643 0 foo 2020-07-04T16:07:23,001
1593871644 1593871644 0 bar 2020-07-04T16:07:23,005
1593871648 1593871648 0 baz 2020-07-04T16:07:24,100" ]
}
@test "identical ISO 8601 timestamps as third field explicitly specified with kept both concatenated timestamps" {
    run timestampTally --timestamp-field 3 --keep-timestamp both-concatenated <<<"$input"

    [ $status -eq 0 ]
    [ "$output" = "1593871643 foo 2020-07-04T16:07:23,001 2020-07-04T16:07:23,001 0
1593871644 bar 2020-07-04T16:07:23,005 2020-07-04T16:07:23,005 0
1593871648 baz 2020-07-04T16:07:24,100 2020-07-04T16:07:24,100 0" ]
}

@test "identical RFC 3339 timestamps as third and fourth fields explicitly specified with kept both concatenated timestamps" {
    run timestampTally --timestamp-field 3,4 --keep-timestamp both-concatenated <<<"${input//T/ }"

    [ $status -eq 0 ]
    [ "$output" = "1593871643 foo 2020-07-04 16:07:23,001 2020-07-04 16:07:23,001 0
1593871644 bar 2020-07-04 16:07:23,005 2020-07-04 16:07:23,005 0
1593871648 baz 2020-07-04 16:07:24,100 2020-07-04 16:07:24,100 0" ]
}
