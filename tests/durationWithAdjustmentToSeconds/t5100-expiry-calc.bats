#!/usr/bin/env bats

load fixture

@test "calc compare expiry times" {
    while IFS=' ' read -r v1 op v2 expected
    do
	run -0 durationWithAdjustmentToSeconds -- calc "$v1" "$op" "$v2" \
	    && assert_output "$expected" \
	    || fail "$v1 $op $v2 should be $expected"
    done <<'EOF'
0 == 0 1
0 > 0 0
1 < 2 1
1 < 1.01 1
1 == 1.0000 1
-1 < 0 1
-3.14 < -3 1
-3.14 == -3 0
-3.14 > -3 0
EOF
}

@test "calc times" {
    while IFS=' ' read -r v1 op v2 expected
    do
	run -0 durationWithAdjustmentToSeconds -- calc "$v1" "$op" "$v2" \
	    && assert_output "$expected" \
	    || fail "$v1 $op $v2 should be $expected"
    done <<'EOF'
0 + 0 0
1 + 1 2
1 - 3 -2
1 - 0.5 0.5
0 - 0.5 -0.5
1 / 3.0 0.3333333333
EOF
}
