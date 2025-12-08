#!/usr/bin/env bats

load fixture

input="1593871643 foo
1593871643 foo2
1593871643 foo3
1593871644 bar
1593871648 baz
1593871648 baz2"

@test "identical epochs as first field are condensed to the first occurrence with a custom single entry duration of 10 seconds" {
    run -0 timestampTally --single-entry-duration 10 <<<"$input"
    assert_output - <<'EOF'
0 foo
10 bar
0 baz
EOF
}

@test "identical epochs as first field are condensed to the first occurrence with a custom single entry duration of 2 minutes" {
    run -0 timestampTally --single-entry-duration 2m <<<"$input"
    assert_output - <<'EOF'
0 foo
120 bar
0 baz
EOF
}

@test "identical epochs as first field are condensed to the first occurrence with a custom single entry duration of 5 milliseconds" {
    run -0 timestampTally --single-entry-duration 50ms <<<"$input"
    assert_output - <<'EOF'
0 foo
0.050 bar
0 baz
EOF
}
