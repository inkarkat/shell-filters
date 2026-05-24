#!/usr/bin/env bats

load fakeTimer

@test "check after set fractional expiry time of 0.3 expires immediately, then expires on the third check after reset, then expires on the second check after reset to integer 2" {
    run -0 durationWithAdjustmentToSeconds -- set 0.300 check reset 0.300 check check check reset 2 check check reset 2 check check
    assert_output - <<'EOF'
🕔 99.700000
expired
🕔 100.101
remaining
remaining
expired
⏱️ 0
remaining
expired
⏱️ 0
remaining
expired
EOF
}

@test "check after set integer expiry time of 2 expires immediately, then expires on the second check after reset, then expires on the third check after reset to fractional 0.25" {
    run -0 durationWithAdjustmentToSeconds -- set 2 check reset 2 check check reset 0.250 check check check reset 0.250 check check check
    assert_output - <<'EOF'
⏱️ 2
expired
⏱️ 0
remaining
expired
🕔 100.000
remaining
remaining
expired
🕔 100.297
remaining
remaining
expired
EOF
}
