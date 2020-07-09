#!/usr/bin/env bats

load data

@test "close ISO 8601 timestamps as third field explicitly specified and entry duration of 100 ms and single entry duration of 1 minute are summarized based on the first three letters" {
    run timestampTally --timestamp-field 3 --entry-duration 100ms --single-entry-duration 1m --summarize '\<[[:alpha:]]{3}' <<<"$delayedMixedDates"

    [ $status -eq 0 ]
    [ "$output" = "2.100 foo
60 bar
52.077 baz" ]
}

@test "close RFC 3339 timestamps and entry duration of 100 ms and single entry duration of 1 minute are summarized based on the first three letters" {
    run timestampTally --timestamp-field 3-4 --entry-duration 100ms --single-entry-duration 1m --summarize '\<[[:alpha:]]{3}' <<<"${delayedMixedDates//T/ }"

    [ $status -eq 0 ]
    [ "$output" = "2.100 foo
60 bar
52.077 baz" ]
}
