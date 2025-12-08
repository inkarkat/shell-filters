#!/usr/bin/env bats

load fixture

@test "epochs with a break in time and summary field are summarized" {
    run -0 timestampTally --summarize 2 <<'EOF'
1612090000 FOO
1612090060 FOO
1612090120 FOO
1612090180 FOO
1612090240 BAR
1612096300 FOO
1612096360 FOO
EOF
    assert_output - <<'EOF'
240 FOO
0 BAR
EOF
}

@test "subsequent epochs with a break in time but identical field are summarized" {
    run -0 timestampTally --summarize 2 <<'EOF'
1612089940 XXX
1612090000 FOO
1612090060 FOO
1612090120 FOO
1612090180 FOO
1612096000 FOO
1612096060 FOO
EOF
    assert_output - <<'EOF'
0 XXX
6060 FOO
EOF
}

@test "first epochs with a break in time but identical field are summarized" {
    run -0 timestampTally --summarize 2 <<'EOF'
1612090000 FOO
1612090060 FOO
1612090120 FOO
1612090180 FOO
1612096000 FOO
1612096060 FOO
EOF
    assert_output '6060 FOO'
}

@test "epochs with entry duration and a break in time and summary field are summarized" {
    run -0 timestampTally --max-difference 70 --entry-duration 60 --summarize 2 <<'EOF'
1612090000 FOO
1612090060 FOO
1612090120 FOO
1612090180 FOO
1612090240 BAR
1612096300 FOO
1612096360 FOO
EOF
    assert_output - <<'EOF'
360 FOO
60 BAR
EOF
}

@test "subsequent epochs with entry duration and a break in time but identical field are summarized" {
    run -0 timestampTally --max-difference 70 --entry-duration 60 --summarize 2 <<'EOF'
1612089940 XXX
1612090000 FOO
1612090060 FOO
1612090120 FOO
1612090180 FOO
1612096000 FOO
1612096060 FOO
EOF
    assert_output - <<'EOF'
60 XXX
360 FOO
EOF
}

@test "first epochs with entry duration and a break in time but identical field are summarized" {
    run -0 timestampTally --max-difference 70 --entry-duration 60 --summarize 2 <<'EOF'
1612090000 FOO
1612090060 FOO
1612090120 FOO
1612090180 FOO
1612096000 FOO
1612096060 FOO
EOF
    assert_output '360 FOO'
}
