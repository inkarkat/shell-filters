#!/usr/bin/env bats

load data

@test "close ISO 8601 timestamps within 1 minute as third field explicitly specified and entry duration of 100 ms are condensed to the first occurrence" {
    run timestampTally --timestamp-field 3 --max-difference 1m --entry-duration 100ms <<<"$delayedMixedDates"

    [ $status -eq 0 ]
    [ "$output" = "1593871643 foo 2.100
1593871800 bar 0.100
1593871810 baz 52.077" ]
}

@test "close ISO 8601 timestamps within 1 minute as third field explicitly specified and entry duration of 100 ms and single entry duration of 1 minute are condensed to the first occurrence" {
    run timestampTally --timestamp-field 3 --max-difference 1m --entry-duration 100ms --single-entry-duration 1m <<<"$delayedMixedDates"

    [ $status -eq 0 ]
    [ "$output" = "1593871643 foo 2.100
1593871800 bar 60
1593871810 baz 52.077" ]
}
