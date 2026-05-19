#!/usr/bin/env bats

load fixture

@test "multiple passed durations and percentage adjustments are converted to seconds separately" {
    run -0 durationWithAdjustmentToSeconds -- '1s+1000%' '02:30+9%' '2h 30m - 9%' '1h 15m 30s+100%' '0y+5%'
    assert_output - <<'EOF'
11
164
8190
9060
0
EOF
}

@test "multiple passed durations and adjusted timespans are converted to seconds separately" {
    run -0 durationWithAdjustmentToSeconds -- '1s + 1m 11s' '02:30-01:11' '2m 30s - 0m 15s' '02:30+01:02:03' '2w 3d -1d 2h 3m 4s'
    assert_output - <<'EOF'
72
79
135
3873
1375016
EOF
}

@test "invalid durations among multiple passed durations are skipped and exits with 1" {
    run -1 durationWithAdjustmentToSeconds -- 1s+notAnAdjustment '1s+1s' '1h - what' 02:30 '1x +1h'
    assert_output - <<'EOF'
ERROR: Illegal ADJUSTMENT-TIMESPAN: +notAnAdjustment
2
ERROR: Illegal ADJUSTMENT-TIMESPAN: -what
150
ERROR: Illegal TIMESPAN: 1x
EOF
}
