#!/usr/bin/env bats

load fixture

@test "durations read from stdin are converted to seconds separately" {
    run -0 durationToSeconds <<'EOF'
1s
02:30
2h 30m
1h 15m 30s
0y
EOF
    assert_output - <<'EOF'
1
150
9000
4530
0
EOF
}

@test "durations read from stdin can occur anywhere in the input" {
    run -0 durationToSeconds <<'EOF'
1s, 02:30 and more text.
Waiting for 2h 30m.
Newsflash: "1h 15m 30s"
Not a year: 1yes
Wrong order: 15m 1h 30s
EOF
    assert_output - <<'EOF'
1, 150 and more text.
Waiting for 9000.
Newsflash: "4530"
Not a year: 1yes
Wrong order: 900 3630
EOF
}

@test "a negative duration among multiple durations read from stdin is converted because the minus sign is not parsed" {
    run -0 durationToSeconds <<'EOF'
1s
02:30
-2h 30m
1h 15m 30s
0y
EOF
    assert_output - <<'EOF'
1
150
-9000
4530
0
EOF
}

@test "invalid durations among multiple durations read from stdin are skipped" {
    run -0 durationToSeconds <<'EOF'
notADuration
1s
1h and what
02:30
EOF
    assert_output - <<'EOF'
notADuration
1
3600 and what
150
EOF
}
