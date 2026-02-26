#!/usr/bin/env bats

load fixture
load data

@test "identical epochs as first field with kept end epoch" {
    run -0 timestampTally --keep-epoch end <<<"$identicalMixedDates"
    assert_output - <<'EOF'
1593871643 0 foo3 2020-07-04T16:07:23,001
1593871644 0 bar 2020-07-04T16:07:23,005
1593871648 0 baz2 2020-07-04T16:07:24,100
EOF
}

@test "identical epochs as first field explicitly specified with kept end epoch" {
    run -0 timestampTally --timestamp-field 1 --keep-epoch end <<<"$identicalMixedDates"
    assert_output - <<'EOF'
1593871643 0 foo3 2020-07-04T16:07:23,001
1593871644 0 bar 2020-07-04T16:07:23,005
1593871648 0 baz2 2020-07-04T16:07:24,100
EOF
}

@test "identical ISO 8601 timestamps as third field explicitly specified with kept end epoch" {
    run -0 timestampTally --timestamp-field 3 --keep-epoch end <<<"$identicalMixedDates"
    assert_output - <<'EOF'
1593871643 foo3 1593878843,001 0
1593871644 bar 1593878843,005 0
1593871648 baz2 1593878844,100 0
EOF
}

@test "identical RFC 3339 timestamps as third and fourth fields explicitly specified with kept end epoch" {
    run -0 timestampTally --timestamp-field 3,4 --keep-epoch end <<<"${identicalMixedDates//T/ }"
    assert_output - <<'EOF'
1593871643 foo3 1593878843,001 0
1593871644 bar 1593878843,005 0
1593871648 baz2 1593878844,100 0
EOF
}
