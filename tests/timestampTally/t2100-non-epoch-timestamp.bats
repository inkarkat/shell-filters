#!/usr/bin/env bats

load fixture

input="2020-07-04T16:07:23 foo
2020-07-04T16:07:23 foo2
2020-07-04T16:07:23 foo3
2020-07-04T16:07:24 bar
2020-07-04T16:07:28 baz
2020-07-04T16:07:28 baz2"

@test "identical ISO 8601 timestamps as first field are condensed to the first occurrence" {
    run -0 timestampTally <<<"$input"
    assert_output - <<'EOF'
0 foo
0 bar
0 baz
EOF
}

@test "identical ISO 8601 timestamps as first field explicitly specified are condensed to the first occurrence" {
    run -0 timestampTally --timestamp-field 1 <<<"$input"
    assert_output - <<'EOF'
0 foo
0 bar
0 baz
EOF
}

@test "identical RFC 3339 timestamps as first field are condensed to the first occurrence" {
    run -0 timestampTally <<<"${input//T/ }"
    assert_output - <<'EOF'
0 foo
0 bar
0 baz
EOF
}

@test "identical RFC 3339 timestamps as first two fields explicitly specified are condensed to the first occurrence with the second field kept empty" {
    run -0 timestampTally --timestamp-field 1-2 <<<"${input//T/ }"
    assert_output - <<'EOF'
0  foo
0  bar
0  baz
EOF
}

@test "identical RFC 3339 timestamps as first two fields explicitly specified with open range are condensed to the first occurrence with the second field kept empty" {
    run -0 timestampTally --timestamp-field -2 <<<"${input//T/ }"
    assert_output - <<'EOF'
0  foo
0  bar
0  baz
EOF
}

@test "identical RFC 3339 timestamps as fields 1 and 3 explicitly specified are forbidden because they are non-sequential" {
    run -2 timestampTally --timestamp-field 1,3 <<<"${input//T/ what }"
    assert_output 'ERROR: Timestamp field 3 does not follow 1.'
}
