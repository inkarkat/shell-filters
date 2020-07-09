#!/usr/bin/env bats

load data

input="1593871643 foo
1593871644 foo2
1593871647 foo3
1593871648 bar
1593871850 baz
1593871853 baz2"

@test "epochs as first field are condensed to the first occurrence after 3 lines" {
    run timestampTally --max-difference 3 --max-record-length 3 <<<"$input"

    [ $status -eq 0 ]
    [ "$output" = "4 foo
0 bar
3 baz" ]
}

@test "epochs with max record length of 1 are all separate records" {
    run timestampTally --max-difference 3 --max-record-length 1 <<<"$input"

    [ $status -eq 0 ]
    [ "$output" = "0 foo
0 foo2
0 foo3
0 bar
0 baz
0 baz2" ]
}

@test "epochs are condensed to the first occurrence after 3 lines" {
    run timestampTally --max-difference 10ms --max-record-length 3 <<'EOF'
1593871643,900 foo
1593871643,910 foo2
1593871643,920 foo3
1593871644,930 bar
1593871644,940 bar2
1593871644,950 bar3
1593871644,953 baz
1593871644,955 baz2
1593871644,956 baz3
EOF

    [ $status -eq 0 ]
    [ "$output" = "0.020 foo
0.020 bar
0.003 baz" ]
}

@test "ISO 8601 timestamps are condensed to the first occurrence after two lines" {
    run timestampTally --timestamp-field 3 --max-difference 500ms --max-record-length 2 --single-entry-duration 1m <<<"$delayedMixedDates"

    [ $status -eq 0 ]
    [ "$output" = "1593871643 foo 0.001
1593871645 foo3 60
1593871800 bar 60
1593871810 baz 60
1593871861 baz2 60" ]
}

@test "close RFC 3339 timestamps are condensed to the first occurrence after two lines" {
    run timestampTally --timestamp-field 3-4 --max-difference 500ms --max-record-length 2 --single-entry-duration 1m <<<"${delayedMixedDates//T/ }"

    [ $status -eq 0 ]
    [ "$output" = "1593871643 foo 0.001
1593871645 foo3 60
1593871800 bar 60
1593871810 baz 60
1593871861 baz2 60" ]
}

@test "epochs as first field are condensed to the first occurrence after 3 lines when lines without timestamp are interspersed" {
    run timestampTally --max-difference 3 --max-record-length 3 <<'EOF'
This is an odd line.
1593871643 foo
1593871644 foo2
1593871647 foo3
1593871648 bar
1593871850 baz
More odd lines.
In here.
1593871853 baz2
Final odd line.
1593871854 baz3
1593871855 quux
EOF

    [ $status -eq 0 ]
    [ "$output" = "This is an odd line.
4 foo
0 bar
4 baz
More odd lines.
In here.
Final odd line.
0 quux" ]
}
