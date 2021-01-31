#!/usr/bin/env bats

@test "epochs with a break in time and summary field are summarized" {
    run timestampTally --summarize 2 <<'EOF'
1612090000 FOO
1612090060 FOO
1612090120 FOO
1612090180 FOO
1612090240 BAR
1612096300 FOO
1612096360 FOO
EOF
    [ $status -eq 0 ]
    [ "$output" = "240 FOO
0 BAR" ]
}

@test "subsequent epochs with a break in time but identical field are summarized" {
    run timestampTally --summarize 2 <<'EOF'
1612089940 XXX
1612090000 FOO
1612090060 FOO
1612090120 FOO
1612090180 FOO
1612096000 FOO
1612096060 FOO
EOF
    [ "$output" = "0 XXX
6060 FOO" ]
}

@test "first epochs with a break in time but identical field are summarized" {
    run timestampTally --summarize 2 <<'EOF'
1612090000 FOO
1612090060 FOO
1612090120 FOO
1612090180 FOO
1612096000 FOO
1612096060 FOO
EOF
    [ $status -eq 0 ]
    [ "$output" = "6060 FOO" ]
}

@test "epochs with entry duration and a break in time and summary field are summarized" {
    run timestampTally --max-difference 70 --entry-duration 60 --summarize 2 <<'EOF'
1612090000 FOO
1612090060 FOO
1612090120 FOO
1612090180 FOO
1612090240 BAR
1612096300 FOO
1612096360 FOO
EOF
    [ $status -eq 0 ]
    [ "$output" = "360 FOO
60 BAR" ]
}

@test "subsequent epochs with entry duration and a break in time but identical field are summarized" {
    run timestampTally --max-difference 70 --entry-duration 60 --summarize 2 <<'EOF'
1612089940 XXX
1612090000 FOO
1612090060 FOO
1612090120 FOO
1612090180 FOO
1612096000 FOO
1612096060 FOO
EOF
    [ $status -eq 0 ]
    [ "$output" = "60 XXX
360 FOO" ]
}

@test "first epochs with entry duration and a break in time but identical field are summarized" {
    run timestampTally --max-difference 70 --entry-duration 60 --summarize 2 <<'EOF'
1612090000 FOO
1612090060 FOO
1612090120 FOO
1612090180 FOO
1612096000 FOO
1612096060 FOO
EOF
    [ $status -eq 0 ]
    [ "$output" = "360 FOO" ]
}
