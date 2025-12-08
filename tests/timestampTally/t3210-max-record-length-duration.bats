#!/usr/bin/env bats

load fixture

@test "ISO 8601 timestamps are condensed to the first occurrence after 3 lines or 25 ms, whatever comes first" {
    run -0 timestampTally --max-difference 25ms --max-record-duration 25ms --max-record-length 3 <<'EOF'
1593871644,800 foo
1593871644,810 foo2
1593871644,920 bar
1593871644,925 bar2
1593871644,930 bar3
1593871644,935 baz
1593871644,940 baz2
1593871644,990 quux
1593871644,999 quux2
EOF

    assert_output - <<'EOF'
0.010 foo
0.010 bar
0.005 baz
0.009 quux
EOF
}
