#!/usr/bin/env bats

load fixture

@test "identical epochs as third field are condensed to the first occurrence" {
    run -0 timestampTally --timestamp-field 3 <<'EOF'
1000000000 x 1593871643 foo
1000000000 x 1593871643 foo2
1000000000 x 1593871643 foo3
1000000000 x 1593871644 bar
1000000000 x 1593871648 baz
1000000000 x 1593871648 baz2
EOF

    assert_output - <<'EOF'
1000000000 x 0 foo
1000000000 x 0 bar
1000000000 x 0 baz
EOF
}
