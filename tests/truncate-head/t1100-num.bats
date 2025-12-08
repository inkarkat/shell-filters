#!/usr/bin/env bats

load fixture

@test "a single line of 3 is kept" {
    run -0 truncate-head -n 3 <<-'EOF'
Single line
EOF
    assert_output 'Single line'
}

@test "three lines of 3 are kept" {
    run -0 truncate-head -n 3 <<-'EOF'
foo 1
foo 2
foo 3
EOF
    assert_output - <<'EOF'
foo 1
foo 2
foo 3
EOF
}
@test "four lines of 3 are truncated after 3" {
    run -0 truncate-head -n 3 <<-'EOF'
foo 1
foo 2
foo 3
foo 4
EOF
    assert_output - <<'EOF'
foo 1
foo 2
foo 3
[...]
EOF
}
@test "a single line of 1 is kept" {
    run -0 truncate-head -n 1 <<-'EOF'
Single line
EOF
    assert_output 'Single line'
}

@test "two lines of 1 are truncated after 1" {
    run -0 truncate-head -n 1 <<-'EOF'
foo 1
foo 2
EOF
    assert_output - <<'EOF'
foo 1
[...]
EOF
}
