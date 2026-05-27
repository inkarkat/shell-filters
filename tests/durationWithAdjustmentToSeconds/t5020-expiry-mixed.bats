#!/usr/bin/env bats

load fakeTimer

@test "check after set fractional expiry time of 0.3 expires immediately, then expires on the third check after reset, then expires on the second check after reset to integer 2" {
    run -0 durationWithAdjustmentToSeconds -- set 0.300 check reset 0.300 check check check reset 2 check check reset 2 check check
    assert_output - <<'EOF'
🕔 99.7
-.1010000000
🕔 100.101
.2120000000
.1040000000
-.0030000000
⏱️ 0
1
-0
⏱️ 0
1
-0
EOF
}

@test "check after set integer expiry time of 2 expires immediately, then expires on the second check after reset, then expires on the third check after reset to fractional 0.25" {
    run -0 durationWithAdjustmentToSeconds -- set 2 check reset 2 check check reset 0.250 check check check reset 0.250 check check check
    assert_output - <<'EOF'
⏱️ 2
-1
⏱️ 0
1
-0
🕔 100
.1490000000
.0610000000
-.0470000000
🕔 100.297
.1430000000
.0350000000
-.0550000000
EOF
}
