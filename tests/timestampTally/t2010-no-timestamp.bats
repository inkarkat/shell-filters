#!/usr/bin/env bats

load fixture

@test "lines without timestamp are redirected to stderr" {
    input="this has no time
1593871643 foo
1593871644 bar
this also is odd
as is this
1593871648 baz
and the last one as well"

    run -0 timestampTally <<<"$input"
    assert_output - <<'EOF'
this has no time
0 foo
0 bar
this also is odd
as is this
0 baz
and the last one as well
EOF

    run -0 --separate-stderr timestampTally <<<"$input"
    assert_output - <<'EOF'
0 foo
0 bar
0 baz
EOF

    run -0 --separate-stderr timestampTally <<<"$input"
    output="$stderr" assert_output - <<'EOF'
this has no time
this also is odd
as is this
and the last one as well
EOF
}
