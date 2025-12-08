#!/usr/bin/env bats

load fixture
load data

input="1593871643 foo
1593871644 foo2
1593871647 foo3
1593871651 bar
1593871850 baz
1593871853 baz2"

@test "close epochs within 3 seconds as first field are condensed to the first occurrence" {
    run -0 timestampTally --max-difference 3 <<<"$input"
    assert_output - <<'EOF'
4 foo
0 bar
3 baz
EOF
}

@test "close epochs within 3 seconds as first field explicitly specified are condensed to the first occurrence" {
    run -0 timestampTally --timestamp-field 1 --max-difference 3 <<<"$input"
    assert_output - <<'EOF'
4 foo
0 bar
3 baz
EOF
}

@test "close epochs with millis within 1 second as first field are condensed to the first occurrence" {
    run -0 timestampTally --max-difference 1 <<'EOF'
1593871643,101 foo
1593871644,100 foo
1593871645,100 foo
1593871646,101 bar
1593871647,102 baz
EOF

    assert_output - <<'EOF'
1.999 foo
0 bar
0 baz
EOF
}

@test "close epochs with millis within 100 ms as first field are condensed to the first occurrence" {
    run -0 timestampTally --max-difference 100ms <<'EOF'
1593871643,900 foo
1593871643,999 foo
1593871644,042 foo
1593871644,201 bar
1593871644,202 bar
1593871644,303 baz
EOF

    assert_output - <<'EOF'
0.142 foo
0.001 bar
0 baz
EOF
}

@test "close epochs with millis with different resolutions are handled" {
    run -0 timestampTally --max-difference 1 <<'EOF'
1593871643,101 foo
1593871644,1 foo
1593871645,10 foo
1593871646,101 bar
1593871647 bar
1593871648,1 baz
1593871649,11111 baz
1593871650,001 quux
EOF

    assert_output - <<'EOF'
1.999 foo
0.899 bar
0.900 baz
0 quux
EOF
}

@test "close ISO 8601 timestamps within 1 minute as third field explicitly specified and single entry duration of 1 minute are condensed to the first occurrence" {
    run -0 timestampTally --timestamp-field 3 --max-difference 1m --single-entry-duration 1m <<<"$delayedMixedDates"
    assert_output - <<'EOF'
1593871643 foo 2
1593871800 bar 60
1593871810 baz 51.977
EOF
}

@test "close RFC 3339 timestamps within 1 minute as third field explicitly specified and single entry duration of 1 minute are condensed to the first occurrence" {
    run -0 timestampTally --timestamp-field 3-4 --max-difference 1m --single-entry-duration 1m <<<"${delayedMixedDates//T/ }"
    assert_output - <<'EOF'
1593871643 foo 2
1593871800 bar 60
1593871810 baz 51.977
EOF
}
