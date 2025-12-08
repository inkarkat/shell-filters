#!/usr/bin/env bats

load fixture
load data

@test "close ISO 8601 timestamps as third field explicitly specified and entry duration of 100 ms and single entry duration of 1 minute are summarized based on the first three letters" {
    run -0 timestampTally --timestamp-field 3 --entry-duration 100ms --single-entry-duration 1m --summarize '\<[[:alpha:]]{3}' <<<"$delayedMixedDates"
    assert_output - <<'EOF'
2.100 foo
60 bar
52.077 baz
EOF
}

@test "close RFC 3339 timestamps and entry duration of 100 ms and single entry duration of 1 minute are summarized based on the first three letters" {
    run -0 timestampTally --timestamp-field 3-4 --entry-duration 100ms --single-entry-duration 1m --summarize '\<[[:alpha:]]{3}' <<<"${delayedMixedDates//T/ }"
    assert_output - <<'EOF'
2.100 foo
60 bar
52.077 baz
EOF
}
