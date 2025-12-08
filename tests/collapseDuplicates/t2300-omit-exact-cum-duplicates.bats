#!/usr/bin/env bats

load fixture

@test "one duplicate line is omitted" {
    run -0 collapseDuplicates --match-accumulated '.*' <<-'EOF'
Just some text.
This repeats once.
This repeats once.
Seriously.
EOF
    assert_output - <<'EOF'
Just some text.
This repeats once.
Seriously.
EOF
}

@test "three duplicate lines are omitted" {
    run -0 collapseDuplicates --match-accumulated '.*' <<-'EOF'
Just some text.
This repeats once.
This repeats once.
This repeats once.
This repeats once.
Seriously.
EOF
    assert_output - <<'EOF'
Just some text.
This repeats once.
Seriously.
EOF
}

@test "duplicate suppression works multiple times" {
    run -0 collapseDuplicates --match-accumulated '.*' <<-'EOF'
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
This repeats once.
A unique statement.
Not unique.
Seriously.
EOF
}

@test "duplicate suppression in multiple locations" {
    run -0 collapseDuplicates --match-accumulated '.*' <<-'EOF'
This repeats once.
This repeats once.
This repeats once.
A unique statement.
End of interlude.
This repeats once.
This repeats once.
EOF
    assert_output - <<'EOF'
This repeats once.
A unique statement.
End of interlude.
This repeats once.
EOF
}
