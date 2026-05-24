#!/usr/bin/env bats

load fakeTimer

@test "set integer expiry time prints that time because it should expire immediately" {
    run -0 durationWithAdjustmentToSeconds -- set 5
    assert_output '⏱️ 5'
}

@test "reset integer expiry time prints 0 as the timer is starting" {
    run -0 durationWithAdjustmentToSeconds -- reset 3
    assert_output '⏱️ 0'
}

@test "check after set integer expiry time expires immediately" {
    run -0 durationWithAdjustmentToSeconds -- set 5 check check check
    assert_output - <<'EOF'
⏱️ 5
expired
expired
expired
EOF
}

@test "check after set integer expiry time of 3 expires immediately and then expires on the third check after reset" {
    run -0 durationWithAdjustmentToSeconds -- set 3 check reset 3 check check check
    assert_output - <<'EOF'
⏱️ 3
expired
⏱️ 0
remaining
remaining
expired
EOF
}

@test "check after set integer expiry time of 3 expires immediately and then expires on the fourth check after reset 4 and then on the second check after reset 2" {
    run -0 durationWithAdjustmentToSeconds -- set 3 check reset 4 check check check check reset 2 check check
    assert_output - <<'EOF'
⏱️ 3
expired
⏱️ 0
remaining
remaining
remaining
expired
⏱️ 0
remaining
expired
EOF
}

@test "check after set integer expiry time of 3 and initial timeout of 2 expires on the fifth check and then repeats with period of 3 after reset" {
    run -0 durationWithAdjustmentToSeconds -- set 3 2 check check reset 3 check check check
    assert_output - <<'EOF'
⏱️ 1
remaining
expired
⏱️ 0
remaining
remaining
expired
EOF
}

@test "check after set integer expiry time of 7 and initial timeout of 3 expires on the fifth check and then repeats with period of 7 after reset" {
    run -0 durationWithAdjustmentToSeconds -- set 7 3 check check check reset 7 check check check check check check check
    assert_output - <<'EOF'
⏱️ 4
remaining
remaining
expired
⏱️ 0
remaining
remaining
remaining
remaining
remaining
remaining
expired
EOF
}
