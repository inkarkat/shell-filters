#!/usr/bin/env bats

load fixture

input="2020-07-04T16:07:23,001 foo
2020-07-04T16:07:23,001 foo2
2020-07-04T16:07:23,002 bar
2020-07-04T16:07:23,123 baz
2020-07-04T16:07:23,123 baz2
2020-07-04T16:07:23,123 baz3
2020-07-04T16:07:24,123 quux"

@test "identical ISO 8601 timestamps with millis as first field are condensed to the first occurrence" {
    run -0 timestampTally <<<"$input"
    assert_output - <<'EOF'
0 foo
0 bar
0 baz
0 quux
EOF
}

@test "identical ISO 8601 timestamps with millis as first field explicitly specified are condensed to the first occurrence" {
    run -0 timestampTally --timestamp-field 1 <<<"$input"
    assert_output - <<'EOF'
0 foo
0 bar
0 baz
0 quux
EOF
}

@test "ISO 8601 timestamps with and without millis are treated as different except when 0" {
    run -0 timestampTally <<'EOF'
2020-07-04T16:07:23 foo
2020-07-04T16:07:23,000 foo
2020-07-04T16:07:24,123 bar
2020-07-04T16:07:24 baz
2020-07-04T16:07:25,0 quux
2020-07-04T16:07:25,0000 quux
EOF

    assert_output - <<'EOF'
0 foo
0 bar
0 baz
0 quux
EOF
}

@test "identical RFC 3339 timestamps with millis as first field are condensed to the first occurrence" {
    run -0 timestampTally <<<"${input//T/ }"
    assert_output - <<'EOF'
0 foo
0 bar
0 baz
0 quux
EOF
}

@test "identical RFC 3339 timestamps with millis as first two fields explicitly specified are condensed to the first occurrence with the second field kept empty" {
    run -0 timestampTally --timestamp-field 1-2 <<<"${input//T/ }"
    assert_output - <<'EOF'
0  foo
0  bar
0  baz
0  quux
EOF
}

@test "identical RFC 3339 timestamps with millis as first two fields explicitly specified with open range are condensed to the first occurrence with the second field kept empty" {
    run -0 timestampTally --timestamp-field -2 <<<"${input//T/ }"
    assert_output - <<'EOF'
0  foo
0  bar
0  baz
0  quux
EOF
}

