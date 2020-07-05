#!/usr/bin/env bats

input="1593871643,001 foo
1593871643,001 foo2
1593871643,002 bar
1593871643,123 baz
1593871643,123 baz2
1593871643,123 baz3
1593871644,123 quux"

@test "identical epochs and millis as first field are condensed to the first occurrence" {
    run timestampTally <<<"$input"

    [ $status -eq 0 ]
    [ "$output" = "0 foo
0 bar
0 baz
0 quux" ]
}

@test "identical epochs as first field explicitly specified are condensed to the first occurrence" {
    run timestampTally --timestamp-field 1 <<<"$input"

    [ $status -eq 0 ]
    [ "$output" = "0 foo
0 bar
0 baz
0 quux" ]
}

@test "same epoch with and without millis are treated as different except when 0" {
    run timestampTally <<'EOF'
1593871643 foo
1593871643,000 foo
1593871644,123 bar
1593871644 baz
1593871645,0 quux
1593871645,0000 quux
EOF

    [ $status -eq 0 ]
    [ "$output" = "0 foo
0 bar
0 baz
0 quux" ]
}
