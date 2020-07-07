#!/usr/bin/env bats

load data

input="1593871643 foo
1593871644 foo2
1593871647 foo3
1593871648 bar
1593871850 baz
1593871853 baz2"

@test "epochs as first field are condensed to the first occurrence after 4 seconds" {
    run timestampTally --max-difference 3 --max-record-duration 4 <<<"$input"

    [ $status -eq 0 ]
    [ "$output" = "4 foo
0 bar
3 baz" ]
}

@test "epochs with max record duration of 0 are all separate records and prints a warning" {
    run timestampTally --max-difference 3 --max-record-duration 0 <<<"$input"

    [ $status -eq 0 ]
    [ "$output" = "Warning: The smaller maximum record duration of 0 shadows the larger maximum difference 3 between subsequent lines.
0 foo
0 foo2
0 foo3
0 bar
0 baz
0 baz2" ]
}

@test "epochs with smaller max record duration than max difference take precedence and prints a warning" {
    run timestampTally --max-difference 3 --max-record-duration 2 <<<"$input"

    [ $status -eq 0 ]
    [ "$output" = "Warning: The smaller maximum record duration of 2 shadows the larger maximum difference 3 between subsequent lines.
1 foo
1 foo3
0 baz
0 baz2" ]
}

@test "epochs are condensed to the first occurrence after 25 millis" {
    run timestampTally --max-difference 10ms --max-record-duration 25ms <<'EOF'
1593871643,900 foo
1593871643,910 foo2
1593871643,920 foo3
1593871644,030 bar
1593871644,040 bar2
1593871644,050 bar3
1593871644,053 bar4
1593871644,055 bar5
1593871644,056 baz
EOF

    [ $status -eq 0 ]
    [ "$output" = "0.020 foo
0.025 bar
0 baz" ]
}

@test "ISO 8601 timestamps are condensed to the first occurrence after one second" {
    run timestampTally --timestamp-field 3 --max-difference 500ms --max-record-duration 1 --single-entry-duration 1m <<<"$delayedMixedDates"

    [ $status -eq 0 ]
    [ "$output" = "1593871643 foo 0.001
1593871645 foo3 60
1593871800 bar 60
1593871810 baz 60
1593871861 baz2 60" ]
}

@test "close RFC 3339 timestamps are condensed to the first occurrence after one second" {
    run timestampTally --timestamp-field 3-4 --max-difference 500ms --max-record-duration 1 --single-entry-duration 1m <<<"${delayedMixedDates//T/ }"

    [ $status -eq 0 ]
    [ "$output" = "1593871643 foo 0.001
1593871645 foo3 60
1593871800 bar 60
1593871810 baz 60
1593871861 baz2 60" ]
}
