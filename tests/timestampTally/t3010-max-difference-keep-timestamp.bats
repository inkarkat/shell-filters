#!/usr/bin/env bats

load fixture
load data

@test "close RFC 3339 timestamps within 1 minute as third field explicitly specified and single entry duration of 1 minute with kept start timestamp" {
    run -0 timestampTally --timestamp-field 3-4 --keep-timestamp start --max-difference 1m --single-entry-duration 1m <<<"${delayedMixedDates//T/ }"
    assert_output - <<'EOF'
1593871643 foo 2020-07-04 16:07:23,001 2
1593871800 bar 2020-07-04 16:10:00,011 60
1593871810 baz 2020-07-04 16:40:10,010 51.977
EOF
}

@test "close RFC 3339 timestamps within 1 minute as third field explicitly specified and single entry duration of 1 minute with kept end timestamp" {
    run -0 timestampTally --timestamp-field 3-4 --keep-timestamp end --max-difference 1m --single-entry-duration 1m <<<"${delayedMixedDates//T/ }"
    assert_output - <<'EOF'
1593871645 foo3 2020-07-04 16:07:25,001 2
1593871800 bar 2020-07-04 16:10:00,011 60
1593871861 baz2 2020-07-04 16:41:01,987 51.977
EOF
}

@test "close RFC 3339 timestamps within 1 minute as third field explicitly specified and single entry duration of 1 minute with kept both concatenated timestamps" {
    run -0 timestampTally --timestamp-field 3-4 --keep-timestamp both-concatenated --max-difference 1m --single-entry-duration 1m <<<"${delayedMixedDates//T/ }"
    assert_output - <<'EOF'
1593871643 foo 2020-07-04 16:07:23,001 2020-07-04 16:07:25,001 2
1593871800 bar 2020-07-04 16:10:00,011 2020-07-04 16:10:00,011 60
1593871810 baz 2020-07-04 16:40:10,010 2020-07-04 16:41:01,987 51.977
EOF
}

@test "close RFC 3339 timestamps within 1 minute as third field explicitly specified and single entry duration of 1 minute with kept separate start and end timestamps" {
    run -0 timestampTally --timestamp-field 3-4 --keep-timestamp both-separate --max-difference 1m --single-entry-duration 1m <<<"${delayedMixedDates//T/ }"
    assert_output - <<'EOF'
1593871643 foo 2020-07-04 16:07:23,001 2
1593871645 foo3 2020-07-04 16:07:25,001 2
1593871800 bar 2020-07-04 16:10:00,011 60
1593871810 baz 2020-07-04 16:40:10,010 51.977
1593871861 baz2 2020-07-04 16:41:01,987 51.977
EOF
}
