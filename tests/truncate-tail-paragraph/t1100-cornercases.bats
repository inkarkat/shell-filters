#!/usr/bin/env bats

load fixture

@test "trailing empty line" {
    run -0 truncate-tail-paragraph <<-'EOF'
One
first
paragraph.

Last
paragraph.

EOF
    assert_output - <<'EOF'
Last
paragraph.
EOF
}

@test "two trailing empty lines are kept (questionable implementation artifact)" {
    run -0 truncate-tail-paragraph <<-'EOF'
One
first
paragraph.

Last
paragraph.


EOF
    assert_output ''
}

@test "four trailing empty lines are kept (questionable implementation artifact)" {
    run -0 truncate-tail-paragraph <<-'EOF'
One
first
paragraph.

Last
paragraph.




EOF
    assert_output ''
}
