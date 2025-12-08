#!/usr/bin/env bats

load fixture

@test "no output" {
    run -0 truncate-tail-paragraph <<<""
    assert_output ''
}

@test "a single line is kept" {
    run -0 truncate-tail-paragraph <<-'EOF'
Single line
EOF
    assert_output 'Single line'
}
@test "a single paragraph is kept" {
    run -0 truncate-tail-paragraph <<-'EOF'
Just one
first
paragraph.
EOF
    assert_output - <<'EOF'
Just one
first
paragraph.
EOF
}
@test "only the last of two paragraphs is kept" {
    run -0 truncate-tail-paragraph <<-'EOF'
One
first
paragraph.

Another
paragraph.
EOF
    assert_output - <<'EOF'
Another
paragraph.
EOF
}
@test "a minimal single-line last paragraph is kept" {
    run -0 truncate-tail-paragraph <<-'EOF'
One
first
paragraph.

Another paragraph.
EOF
    assert_output 'Another paragraph.'
}
@test "only the last of four paragraphs is kept" {
    run -0 truncate-tail-paragraph <<-'EOF'
One
first
paragraph.

Second
paragraph.



Third
(a bit later)
one.

The
last
paragraph.
EOF
    assert_output - <<'EOF'
The
last
paragraph.
EOF
}
