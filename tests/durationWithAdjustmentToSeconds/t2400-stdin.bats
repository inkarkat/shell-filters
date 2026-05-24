#!/usr/bin/env bats

load fixture

@test "durations and percentages read from stdin are converted to seconds separately" {
    run -0 durationWithAdjustmentToSeconds <<'EOF'
1s+1%
1s+100%
1s+1000%
2m 30s + 9%
02:30+9%
02:30 +9%
02:30 - 9%
02:30-9%
EOF
    assert_output - <<'EOF'
1
2
11
164
164
164
137
137
EOF
}

@test "durations and timespans read from stdin are converted to seconds separately" {
    run -0 durationWithAdjustmentToSeconds <<'EOF'
1s+1
1s+1s
1s+1m
1s + 1m 11s
1s +01:11
2m 30s - 0m 15s
02:30-01:11
02:30+01:02:03
2w 3d -1d 2h 3m 4s
EOF
    assert_output - <<'EOF'
2
2
61
72
72
135
79
3873
1375016
EOF
}

@test "invalid durations among multiple durations read from stdin exit 1 and print error message" {
    run -1 durationWithAdjustmentToSeconds <<'EOF'
notADuration
1s
1h and what
02:30
1s+1x
EOF
    assert_output - <<'EOF'
ERROR: Illegal TIMESPAN: notADuration
1
ERROR: Illegal TIMESPAN: 1h and what
150
ERROR: Illegal ADJUSTMENT-TIMESPAN: +1x
EOF
}

@test "multiple tab-separated durations read from stdin are converted to seconds separately" {
    run -0 durationWithAdjustmentToSeconds <<'EOF'
1s	02:30	2h 30m
1h 15m 30s	0y
EOF
    assert_output - <<'EOF'
1	150	9000
4530	0
EOF
}

@test "multiple tab-separated durations and percentage adjustments and adjusted timespans read from stdin are converted to seconds separately" {
    run -0 durationWithAdjustmentToSeconds <<'EOF'
1s+1000%	02:30+9%	2h 30m - 9%	1h 15m 30s+100%	0y+5%
1s + 1m 11s	02:30-01:11	2m 30s - 0m 15s	02:30+01:02:03	2w 3d -1d 2h 3m 4s
EOF
    assert_output - <<'EOF'
11	164	8190	9060	0
72	79	135	3873	1375016
EOF
}

@test "multiple tab-separated durations and percentage adjustments and adjusted timespans read from stdin are output separately with --no-adjustment" {
    run -0 durationWithAdjustmentToSeconds --no-adjustment <<'EOF'
1s+1000%	02:30+9%	2h 30m - 9%	1h 15m 30s+100%	0y+5%
1s + 1m 11s	02:30-01:11	2m 30s - 0m 15s	02:30+01:02:03	2w 3d -1d 2h 3m 4s
EOF
    assert_output - <<'EOF'
1	+1000%	150	+9%	9000	-9%	4530	+100%	0	+5%
1	+71	150	-71	150	-15	150	+3723	1468800	-93784
EOF
}
