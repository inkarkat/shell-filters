#!/usr/bin/env bats

load data

@test "identical epochs as first field with kept separate start and end timestamps" {
    run timestampTally --keep-timestamp both-separate <<<"$identicalMixedDates"

    [ $status -eq 0 ]
    [ "$output" = "1593871643 0 foo 2020-07-04T16:07:23,001
1593871643 0 foo3 2020-07-04T16:07:23,001
1593871644 0 bar 2020-07-04T16:07:23,005
1593871648 0 baz 2020-07-04T16:07:24,100
1593871648 0 baz2 2020-07-04T16:07:24,100" ]
}

@test "identical epochs as first field explicitly specified with kept separate start and end timestamps" {
    run timestampTally --timestamp-field 1 --keep-timestamp both-separate <<<"$identicalMixedDates"

    [ $status -eq 0 ]
    [ "$output" = "1593871643 0 foo 2020-07-04T16:07:23,001
1593871643 0 foo3 2020-07-04T16:07:23,001
1593871644 0 bar 2020-07-04T16:07:23,005
1593871648 0 baz 2020-07-04T16:07:24,100
1593871648 0 baz2 2020-07-04T16:07:24,100" ]
}
@test "identical ISO 8601 timestamps as third field explicitly specified with kept separate start and end timestamps" {
    run timestampTally --timestamp-field 3 --keep-timestamp both-separate <<<"$identicalMixedDates"

    [ $status -eq 0 ]
    [ "$output" = "1593871643 foo 2020-07-04T16:07:23,001 0
1593871643 foo3 2020-07-04T16:07:23,001 0
1593871644 bar 2020-07-04T16:07:23,005 0
1593871648 baz 2020-07-04T16:07:24,100 0
1593871648 baz2 2020-07-04T16:07:24,100 0" ]
}

@test "identical RFC 3339 timestamps as third and fourth fields explicitly specified with kept separate start and end timestamps" {
    run timestampTally --timestamp-field 3,4 --keep-timestamp both-separate <<<"${identicalMixedDates//T/ }"

    [ $status -eq 0 ]
    [ "$output" = "1593871643 foo 2020-07-04 16:07:23,001 0
1593871643 foo3 2020-07-04 16:07:23,001 0
1593871644 bar 2020-07-04 16:07:23,005 0
1593871648 baz 2020-07-04 16:07:24,100 0
1593871648 baz2 2020-07-04 16:07:24,100 0" ]
}

@test "a single identical epoch followed by line without timestamp with kept separate start and end timestamps is printed only once" {
    run timestampTally --keep-timestamp both-separate <<'EOF'
1593871643 foo
1593871643 foo2
1593871643 foo3
1593871644 bar
This is the odd line.
1593871648 baz
1593871649 quux
EOF

    [ $status -eq 0 ]
    [ "$output" = "1593871643 0 foo
1593871643 0 foo3
1593871644 0 bar
This is the odd line.
1593871648 0 baz
1593871649 0 quux" ]
}
