#!/usr/bin/env bats

load fixture

@test "no output" {
    run -0 truncate-head <<<""
    assert_output ''
}

@test "a single line is kept" {
    run -0 truncate-head <<-'EOF'
Single line
EOF
    assert_output 'Single line'
}
@test "ten lines are kept" {
    run -0 truncate-head <<-'EOF'
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
    assert_output - <<'EOF'
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
}
@test "eleven lines are truncated after 10" {
    run -0 truncate-head <<-'EOF'
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
    assert_output - <<'EOF'
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
[...]
EOF
}
@test "twenty lines are truncated after 10" {
    run -0 truncate-head <<-'EOF'
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
    assert_output - <<'EOF'
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
[...]
EOF
}
