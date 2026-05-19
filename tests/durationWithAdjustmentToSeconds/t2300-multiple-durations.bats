#!/usr/bin/env bats

load fixture

@test "multiple passed durations are converted to seconds separately" {
    run -0 durationWithAdjustmentToSeconds -- 1s 02:30 '2h 30m' '1h 15m 30s' 0y
    assert_output - <<'EOF'
1
150
9000
4530
0
EOF
}

@test "a negative duration among multiple passed durations is skipped and exits with 1" {
    run -1 durationWithAdjustmentToSeconds -- 1s 02:30 '-2h 30m' '1h 15m 30s'
    assert_output - <<'EOF'
1
150
ERROR: Illegal TIMESPAN: -2h 30m
4530
EOF
}

@test "invalid durations among multiple passed durations are skipped and exits with 1" {
    run -1 durationWithAdjustmentToSeconds -- notADuration 1s '1h and what' 02:30
    assert_output - <<'EOF'
ERROR: Illegal TIMESPAN: notADuration
1
ERROR: Illegal TIMESPAN: 1h and what
150
EOF
}
