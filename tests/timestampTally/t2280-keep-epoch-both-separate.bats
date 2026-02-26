#!/usr/bin/env bats

load fixture
load data

@test "identical epochs as first field with kept separate start and end epochs" {
    run -0 timestampTally --keep-epoch both-separate <<<"$identicalMixedDates"
    assert_output - <<'EOF'
1593871643 0 foo 2020-07-04T16:07:23,001
1593871643 0 foo3 2020-07-04T16:07:23,001
1593871644 0 bar 2020-07-04T16:07:23,005
1593871648 0 baz 2020-07-04T16:07:24,100
1593871648 0 baz2 2020-07-04T16:07:24,100
EOF
}

@test "identical epochs as first field explicitly specified with kept separate start and end epochs" {
    run -0 timestampTally --timestamp-field 1 --keep-epoch both-separate <<<"$identicalMixedDates"
    assert_output - <<'EOF'
1593871643 0 foo 2020-07-04T16:07:23,001
1593871643 0 foo3 2020-07-04T16:07:23,001
1593871644 0 bar 2020-07-04T16:07:23,005
1593871648 0 baz 2020-07-04T16:07:24,100
1593871648 0 baz2 2020-07-04T16:07:24,100
EOF
}

@test "identical ISO 8601 timestamps as third field explicitly specified with kept separate start and end epochs" {
    run -0 timestampTally --timestamp-field 3 --keep-epoch both-separate <<<"$identicalMixedDates"
    assert_output - <<'EOF'
1593871643 foo 1593878843,001 0
1593871643 foo3 1593878843,001 0
1593871644 bar 1593878843,005 0
1593871648 baz 1593878844,100 0
1593871648 baz2 1593878844,100 0
EOF
}

@test "identical RFC 3339 timestamps as third and fourth fields explicitly specified with kept separate start and end epochs" {
    run -0 timestampTally --timestamp-field 3,4 --keep-epoch both-separate <<<"${identicalMixedDates//T/ }"
    assert_output - <<'EOF'
1593871643 foo 1593878843,001 0
1593871643 foo3 1593878843,001 0
1593871644 bar 1593878843,005 0
1593871648 baz 1593878844,100 0
1593871648 baz2 1593878844,100 0
EOF
}

@test "a single identical epoch followed by line without timestamp with kept separate start and end epochs is printed only once" {
    run -0 timestampTally --keep-epoch both-separate <<'EOF'
1593871643 foo
1593871643 foo2
1593871643 foo3
1593871644 bar
This is the odd line.
1593871648 baz
1593871649 quux
EOF

    assert_output - <<'EOF'
1593871643 0 foo
1593871643 0 foo3
1593871644 0 bar
This is the odd line.
1593871648 0 baz
1593871649 0 quux
EOF
}
