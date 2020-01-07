#!/usr/bin/env bats

@test "no output" {
    run truncate-tail-paragraph <<<""
    [ $status -eq 0 ]
    [ "$output" = "" ]
}

@test "a single line is kept" {
    run truncate-tail-paragraph <<-'EOF'
Single line
EOF
    [ $status -eq 0 ]
    [ "$output" = "Single line" ]
}
@test "a single paragraph is kept" {
    run truncate-tail-paragraph <<-'EOF'
Just one
first
paragraph.
EOF
    [ $status -eq 0 ]
    [ "$output" = "Just one
first
paragraph." ]
}
@test "only the last of two paragraphs is kept" {
    run truncate-tail-paragraph <<-'EOF'
One
first
paragraph.

Another
paragraph.
EOF
    [ $status -eq 0 ]
    [ "$output" = "Another
paragraph." ]
}
@test "a minimal single-line last paragraph is kept" {
    run truncate-tail-paragraph <<-'EOF'
One
first
paragraph.

Another paragraph.
EOF
    [ $status -eq 0 ]
    [ "$output" = "Another paragraph." ]
}
@test "only the last of four paragraphs is kept" {
    run truncate-tail-paragraph <<-'EOF'
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
    [ $status -eq 0 ]
    [ "$output" = "The
last
paragraph." ]
}
