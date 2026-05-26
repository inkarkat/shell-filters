#!/usr/bin/env bats

load fakeTimer

@test "set fractional expiry time prints that time because it should expire immediately" {
    run -0 durationWithAdjustmentToSeconds -- set 0.500
    assert_output '🕔 99.5'
}

@test "reset fractional expiry time prints test start time as the timer is starting" {
    run -0 durationWithAdjustmentToSeconds -- reset 0.750
    assert_output '🕔 100'
}

@test "check after set fractional expiry time expires immediately" {
    run -0 durationWithAdjustmentToSeconds -- set 0.500 check check check
    assert_output - <<'EOF'
🕔 99.5
expired
.4120000000
.3040000000
EOF
}

@test "check after set fractional expiry time of 0.5 expires immediately and then expires on the fifth check after reset" {
    run -0 durationWithAdjustmentToSeconds -- set 0.500 check reset 0.500 check check check check check
    assert_output - <<'EOF'
🕔 99.5
expired
🕔 100.101
.4120000000
.3040000000
.1970000000
.0890000000
expired
EOF
}

@test "check after set fractional expiry time of 0.5 expires immediately and then expires on the fourth check after reset 0.4 and then on the second check after reset 0.2" {
    run -0 durationWithAdjustmentToSeconds -- set 0.5 check reset 0.4 check check check check reset 0.2 check check
    assert_output - <<'EOF'
🕔 99.5
expired
🕔 100.101
.3120000000
.2040000000
.0970000000
expired
🕔 100.512
.1100000000
expired
EOF
}

@test "check after set fractional expiry time of 0.5 and initial timeout of 0.2 expires on the third check and then repeats with period of 3 after reset" {
    run -0 durationWithAdjustmentToSeconds -- set 0.5 0.2 check check check reset 0.3 check check check reset 0.3 check check check
    assert_output - <<'EOF'
🕔 99.7
.0990000000
.0110000000
expired
🕔 100.297
.1930000000
.0850000000
expired
🕔 100.602
.1810000000
.0930000000
expired
EOF
}

@test "check after set fractional expiry time of 0.7 and initial timeout of 0.3 expires on the fourth check and then repeats with period of 7 after reset" {
    run -0 durationWithAdjustmentToSeconds -- set 0.7 0.3 check check check check reset 0.7 check check check check check check check reset 0.7
    assert_output - <<'EOF'
🕔 99.6
.1990000000
.1110000000
.0030000000
expired
🕔 100.404
.5920000000
.5020000000
.3830000000
.2950000000
.1960000000
.0870000000
expired
🕔 101.13
EOF
}
