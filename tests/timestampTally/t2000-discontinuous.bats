#!/usr/bin/env bats

@test "discontinuous epochs as first field are printed with timestamp set to zero duration" {
    run timestampTally <<'EOF'
1593871643 foo
1593871644 bar
1593871648 baz
EOF

    [ $status -eq 0 ]
    [ "$output" = "0 foo
0 bar
0 baz" ]
}

@test "discontinuous epochs as last (third) field are printed with timestamp set to zero duration" {
    run timestampTally <<'EOF'
foo is 1593871643
bar has 1593871644
baz was 1593871648
EOF

    [ $status -eq 0 ]
    [ "$output" = "foo is 0
bar has 0
baz was 0" ]
}
