#!/usr/bin/env bats

@test "one duplicate line is counted" {
    run collapseDuplicates --as count --match-accumulated '.*' <<-'EOF'
Just some text.
This repeats once.
This repeats once.
Seriously.
EOF
    [ "$output" = "Just some text.
This repeats once. (2)
Seriously." ]
}

@test "three duplicate lines are counted" {
    run collapseDuplicates --as count --match-accumulated '.*' <<-'EOF'
Just some text.
This repeats once.
This repeats once.
This repeats once.
This repeats once.
Seriously.
EOF
    [ "$output" = "Just some text.
This repeats once. (4)
Seriously." ]
}

@test "duplicate counting works multiple times" {
    run collapseDuplicates --as count --match-accumulated '.*' <<-'EOF'
This repeats once.
This repeats once.
A unique statement.
Not unique.
Not unique.
Seriously.
Seriously.
Seriously.
EOF
    [ "$output" = "This repeats once. (2)
A unique statement.
Not unique. (2)
Seriously. (3)" ]
}

@test "duplicate counting in multiple locations" {
    run collapseDuplicates --as count --match-accumulated '.*' <<-'EOF'
This repeats once.
This repeats once.
This repeats once.
A unique statement.
End of interlude.
This repeats once.
This repeats once.
EOF
    [ "$output" = "This repeats once. (3)
A unique statement.
End of interlude.
This repeats once. (5)" ]
}

@test "duplicate counting accumulated also with single line" {
    run collapseDuplicates --as count --match-accumulated '.*' <<-'EOF'
This repeats once.
This repeats once.
A unique statement.
This repeats once.
End of interlude.
This repeats once.
This repeats once.
EOF
    [ "$output" = "This repeats once. (2)
A unique statement.
This repeats once. (3)
End of interlude.
This repeats once. (5)" ]
}

@test "duplicate counting accumulated also starts with single line" {
    run collapseDuplicates --as count --match-accumulated '.*' <<-'EOF'
This repeats once.
A unique statement.
This repeats once.
End of interlude.
This repeats once.
This repeats once.
EOF
    [ "$output" = "This repeats once.
A unique statement.
This repeats once. (2)
End of interlude.
This repeats once. (4)" ]
}
