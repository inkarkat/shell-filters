#!/usr/bin/env bats

load fixture

input="1593871643 foo
1593871643 foo2
1593871643 foo3
1593871644 bar
1593871648 baz
1593871648 baz2"

@test "identical epochs as first field are condensed to the first occurrence" {
    run -0 timestampTally <<<"$input"
    assert_output - <<'EOF'
0 foo
0 bar
0 baz
EOF
}

@test "identical epochs as first field explicitly specified are condensed to the first occurrence" {
    run -0 timestampTally --timestamp-field 1 <<<"$input"
    assert_output - <<'EOF'
0 foo
0 bar
0 baz
EOF
}
