#!/usr/bin/env bats

@test "a single line of 3 is kept" {
    run truncate-head -n 3 <<-'EOF'
Single line
EOF
    [ $status -eq 0 ]
    [ "$output" = "Single line" ]
}

@test "three lines of 3 are kept" {
    run truncate-head -n 3 <<-'EOF'
foo 1
foo 2
foo 3
EOF
    [ $status -eq 0 ]
    [ "$output" = "foo 1
foo 2
foo 3" ]
}
@test "four lines of 3 are truncated after 3" {
    run truncate-head -n 3 <<-'EOF'
foo 1
foo 2
foo 3
foo 4
EOF
    [ $status -eq 0 ]
    [ "$output" = "foo 1
foo 2
foo 3
[...]" ]
}
@test "a single line of 1 is kept" {
    run truncate-head -n 1 <<-'EOF'
Single line
EOF
    [ $status -eq 0 ]
    [ "$output" = "Single line" ]
}

@test "two lines of 1 are truncated after 1" {
    run truncate-head -n 1 <<-'EOF'
foo 1
foo 2
EOF
    [ $status -eq 0 ]
    [ "$output" = "foo 1
[...]" ]
}
