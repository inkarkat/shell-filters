#!/usr/bin/env bats

@test "no output" {
    run truncate-head <<<""
    [ $status -eq 0 ]
    [ "$output" = "" ]
}

@test "a single line is kept" {
    run truncate-head <<-'EOF'
Single line
EOF
    [ $status -eq 0 ]
    [ "$output" = "Single line" ]
}
@test "ten lines are kept" {
    run truncate-head <<-'EOF'
foo 1
foo 2
foo 3
foo 4
foo 5
foo 6
foo 7
foo 8
foo 9
foo 10
EOF
    [ $status -eq 0 ]
    [ "$output" = "foo 1
foo 2
foo 3
foo 4
foo 5
foo 6
foo 7
foo 8
foo 9
foo 10" ]
}
@test "eleven lines are truncated after 10" {
    run truncate-head <<-'EOF'
foo 1
foo 2
foo 3
foo 4
foo 5
foo 6
foo 7
foo 8
foo 9
foo 10
foo 11
EOF
    [ $status -eq 0 ]
    [ "$output" = "foo 1
foo 2
foo 3
foo 4
foo 5
foo 6
foo 7
foo 8
foo 9
foo 10
[...]" ]
}
@test "twenty lines are truncated after 10" {
    run truncate-head <<-'EOF'
foo 1
foo 2
foo 3
foo 4
foo 5
foo 6
foo 7
foo 8
foo 9
foo 10
foo 11
foo 12
foo 13
foo 14
foo 15
foo 16
foo 17
foo 18
foo 19
foo 20
EOF
    [ $status -eq 0 ]
    [ "$output" = "foo 1
foo 2
foo 3
foo 4
foo 5
foo 6
foo 7
foo 8
foo 9
foo 10
[...]" ]
}
