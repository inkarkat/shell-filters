#!/usr/bin/env bats

load fixture
load data

@test "identical epochs as first field with kept both concatenated epochs" {
    run -0 timestampTally --keep-epoch both-concatenated <<<"$identicalMixedDates"
    assert_output - <<'EOF'
1593871643 1593871643 0 foo 2020-07-04T16:07:23,001
1593871644 1593871644 0 bar 2020-07-04T16:07:23,005
1593871648 1593871648 0 baz 2020-07-04T16:07:24,100
EOF
}

@test "identical epochs as first field explicitly specified with kept both concatenated epochs" {
    run -0 timestampTally --timestamp-field 1 --keep-epoch both-concatenated <<<"$identicalMixedDates"
    assert_output - <<'EOF'
1593871643 1593871643 0 foo 2020-07-04T16:07:23,001
1593871644 1593871644 0 bar 2020-07-04T16:07:23,005
1593871648 1593871648 0 baz 2020-07-04T16:07:24,100
EOF
}

@test "identical ISO 8601 timestamps as third field explicitly specified with kept both concatenated epochs" {
    run -0 timestampTally --timestamp-field 3 --keep-epoch both-concatenated <<<"$identicalMixedDates"
    assert_output - <<'EOF'
1593871643 foo 1593878843,001 1593878843,001 0
1593871644 bar 1593878843,005 1593878843,005 0
1593871648 baz 1593878844,100 1593878844,100 0
EOF
}

@test "identical RFC 3339 timestamps as third and fourth fields explicitly specified with kept both concatenated epochs" {
    run -0 timestampTally --timestamp-field 3,4 --keep-epoch both-concatenated <<<"${identicalMixedDates//T/ }"
    assert_output - <<'EOF'
1593871643 foo 1593878843,001 1593878843,001 0
1593871644 bar 1593878843,005 1593878843,005 0
1593871648 baz 1593878844,100 1593878844,100 0
EOF
}
