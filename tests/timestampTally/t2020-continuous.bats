#!/usr/bin/env bats

@test "identical epochs as first field are condensed to the first occurrence" {
    run timestampTally <<'EOF'
1593871643 foo
1593871643 foo2
1593871643 foo3
1593871644 bar
1593871648 baz
1593871648 baz2
EOF

    [ $status -eq 0 ]
    [ "$output" = "1593871643 foo
1593871644 bar
1593871648 baz" ]
}
