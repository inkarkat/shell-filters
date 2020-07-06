#!/usr/bin/env bats

input="1593871643 foo
1593871644 foo2
1593871647 foo3
1593871651 bar
1593871850 baz
1593871853 baz2"

@test "close epochs within 3 seconds as first field are condensed to the first occurrence" {
    run timestampTally --max-difference 3 <<<"$input"

    [ $status -eq 0 ]
    [ "$output" = "0 foo
0 bar
0 baz" ]
}

@test "close epochs within 3 seconds as first field explicitly specified are condensed to the first occurrence" {
    run timestampTally --timestamp-field 1 --max-difference 3 <<<"$input"

    [ $status -eq 0 ]
    [ "$output" = "0 foo
0 bar
0 baz" ]
}

@test "close epochs with millis within 1 second as first field are condensed to the first occurrence" {
    run timestampTally --max-difference 1 <<'EOF'
1593871643,101 foo
1593871644,100 foo
1593871645,100 foo
1593871646,101 bar
1593871647,102 baz
EOF

    [ $status -eq 0 ]
    [ "$output" = "0 foo
0 bar
0 baz" ]
}

@test "close epochs with millis with different resolutions are handled" {
    run timestampTally --max-difference 1 <<'EOF'
1593871643,101 foo
1593871644,1 foo
1593871645,10 foo
1593871646,101 bar
1593871647 bar
1593871648,1 baz
1593871649,11111 baz
1593871650,001 quux
EOF

    [ $status -eq 0 ]
    [ "$output" = "0 foo
0 bar
0 baz
0 quux" ]
}
