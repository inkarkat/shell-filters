#!/usr/bin/env bats

load data

input="1593871643 foo
1593871644 foo2
1593871647 foo3
1593871651 bar
1593871850 baz
1593871853 baz2"

@test "close epochs within 3 seconds as first field are condensed to the first occurrence" {
    run timestampTally --max-difference 3 <<<"$input"

    [ $status -eq 0 ]
    [ "$output" = "4 foo
0 bar
3 baz" ]
}

@test "close epochs within 3 seconds as first field explicitly specified are condensed to the first occurrence" {
    run timestampTally --timestamp-field 1 --max-difference 3 <<<"$input"

    [ $status -eq 0 ]
    [ "$output" = "4 foo
0 bar
3 baz" ]
}

@test "close epochs with millis within 1 second as first field are condensed to the first occurrence" {
    run timestampTally --max-difference 1 <<'EOF'
1593871643,101 foo
1593871644,100 foo
1593871645,100 foo
1593871646,101 bar
1593871647,102 baz
EOF

    [ $status -eq 0 ]
    [ "$output" = "1.999 foo
0 bar
0 baz" ]
}

@test "close epochs with millis with different resolutions are handled" {
    run timestampTally --max-difference 1 <<'EOF'
1593871643,101 foo
1593871644,1 foo
1593871645,10 foo
1593871646,101 bar
1593871647 bar
1593871648,1 baz
1593871649,11111 baz
1593871650,001 quux
EOF

    [ $status -eq 0 ]
    [ "$output" = "1.999 foo
0.899 bar
0.9 baz
0 quux" ]
}

@test "close ISO 8601 timestamps within 1 minute as third field explicitly specified and single entry duration of 1 minute are condensed to the first occurrence" {
    run timestampTally --timestamp-field 3 --max-difference 1m --single-entry-duration 1m <<<"$delayedMixedDates"

    [ $status -eq 0 ]
    [ "$output" = "1593871643 foo 2
1593871800 bar 60
1593871810 baz 51.977" ]
}

@test "close RFC 3339 timestamps within 1 minute as third field explicitly specified and single entry duration of 1 minute are condensed to the first occurrence" {
    run timestampTally --timestamp-field 3-4 --max-difference 1m --single-entry-duration 1m <<<"${delayedMixedDates//T/ }"

    [ $status -eq 0 ]
    [ "$output" = "1593871643 foo 2
1593871800 bar 60
1593871810 baz 51.977" ]
}
