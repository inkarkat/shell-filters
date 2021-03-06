#!/usr/bin/env bats

load data

@test "identical epochs as first field with kept start timestamp" {
    run timestampTally --keep-timestamp start <<<"$identicalMixedDates"

    [ $status -eq 0 ]
    [ "$output" = "1593871643 0 foo 2020-07-04T16:07:23,001
1593871644 0 bar 2020-07-04T16:07:23,005
1593871648 0 baz 2020-07-04T16:07:24,100" ]
}

@test "identical epochs as first field explicitly specified with kept start timestamp" {
    run timestampTally --timestamp-field 1 --keep-timestamp start <<<"$identicalMixedDates"

    [ $status -eq 0 ]
    [ "$output" = "1593871643 0 foo 2020-07-04T16:07:23,001
1593871644 0 bar 2020-07-04T16:07:23,005
1593871648 0 baz 2020-07-04T16:07:24,100" ]
}
@test "identical ISO 8601 timestamps as third field explicitly specified with kept start timestamp" {
    run timestampTally --timestamp-field 3 --keep-timestamp start <<<"$identicalMixedDates"

    [ $status -eq 0 ]
    [ "$output" = "1593871643 foo 2020-07-04T16:07:23,001 0
1593871644 bar 2020-07-04T16:07:23,005 0
1593871648 baz 2020-07-04T16:07:24,100 0" ]
}

@test "identical RFC 3339 timestamps as third and fourth fields explicitly specified with kept start timestamp" {
    run timestampTally --timestamp-field 3,4 --keep-timestamp start <<<"${identicalMixedDates//T/ }"

    [ $status -eq 0 ]
    [ "$output" = "1593871643 foo 2020-07-04 16:07:23,001 0
1593871644 bar 2020-07-04 16:07:23,005 0
1593871648 baz 2020-07-04 16:07:24,100 0" ]
}



