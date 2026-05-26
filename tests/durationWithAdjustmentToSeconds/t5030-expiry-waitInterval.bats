#!/usr/bin/env bats

load fakeTimer

@test "set integer expiry time with fractional waitInterval uses fractional time immediately" {
    run -0 durationWithAdjustmentToSeconds -- set 2 0
    assert_output '⏱️ 2'

    run -0 durationWithAdjustmentToSeconds -- set 2 0 33.3
    assert_output '🕔 98'
}

@test "reset integer expiry time with fractional waitInterval uses fractional time immediately" {
    run -0 durationWithAdjustmentToSeconds -- set 2 0 reset 2
    assert_output - <<'EOF'
⏱️ 2
⏱️ 0
EOF

    run -0 durationWithAdjustmentToSeconds -- set 2 0 reset 2 33.3
    assert_output - <<'EOF'
⏱️ 2
🕔 100
EOF
}
