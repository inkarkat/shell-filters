#!/usr/bin/env bats

load fixture

@test "discontinuous epochs as first field are printed with timestamp set to zero duration" {
    run -0 timestampTally <<'EOF'
1593871643 foo
1593871644 bar
1593871648 baz
EOF

    assert_output - <<'EOF'
0 foo
0 bar
0 baz
EOF
}

@test "discontinuous epochs as last (third) field are printed with timestamp set to zero duration" {
    run -0 timestampTally <<'EOF'
foo is 1593871643
bar has 1593871644
baz was 1593871648
EOF

    assert_output - <<'EOF'
foo is 0
bar has 0
baz was 0
EOF
}
