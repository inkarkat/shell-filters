#!/usr/bin/env bats

load fixture

@test "one duplicate line is counted" {
    run -0 collapseDuplicates --as count <<-'EOF'
Just some text.
This repeats once.
This repeats once.
Seriously.
EOF
    assert_output - <<'EOF'
Just some text.
This repeats once. (2)
Seriously.
EOF
}

@test "three duplicate lines are counted" {
    run -0 collapseDuplicates --as count <<-'EOF'
Just some text.
This repeats once.
This repeats once.
This repeats once.
This repeats once.
Seriously.
EOF
    assert_output - <<'EOF'
Just some text.
This repeats once. (4)
Seriously.
EOF
}

@test "duplicate counting works multiple times" {
    run -0 collapseDuplicates --as count <<-'EOF'
This repeats once.
This repeats once.
A unique statement.
Not unique.
Not unique.
Seriously.
Seriously.
Seriously.
EOF
    assert_output - <<'EOF'
This repeats once. (2)
A unique statement.
Not unique. (2)
Seriously. (3)
EOF
}

@test "duplicate counting in multiple locations" {
    run -0 collapseDuplicates --as count <<-'EOF'
This repeats once.
This repeats once.
This repeats once.
A unique statement.
End of interlude.
This repeats once.
This repeats once.
EOF
    assert_output - <<'EOF'
This repeats once. (3)
A unique statement.
End of interlude.
This repeats once. (2)
EOF
}
