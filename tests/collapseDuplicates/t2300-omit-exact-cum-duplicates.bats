#!/usr/bin/env bats

@test "one duplicate line is omitted" {
    run collapseDuplicates --match-accumulated '.*' <<-'EOF'
Just some text.
This repeats once.
This repeats once.
Seriously.
EOF
    [ "$output" = "Just some text.
This repeats once.
Seriously." ]
}

@test "three duplicate lines are omitted" {
    run collapseDuplicates --match-accumulated '.*' <<-'EOF'
Just some text.
This repeats once.
This repeats once.
This repeats once.
This repeats once.
Seriously.
EOF
    [ "$output" = "Just some text.
This repeats once.
Seriously." ]
}

@test "duplicate suppression works multiple times" {
    run collapseDuplicates --match-accumulated '.*' <<-'EOF'
This repeats once.
This repeats once.
A unique statement.
Not unique.
Not unique.
Seriously.
Seriously.
Seriously.
EOF
    [ "$output" = "This repeats once.
A unique statement.
Not unique.
Seriously." ]
}

@test "duplicate suppression in multiple locations" {
    run collapseDuplicates --match-accumulated '.*' <<-'EOF'
This repeats once.
This repeats once.
This repeats once.
A unique statement.
End of interlude.
This repeats once.
This repeats once.
EOF
    [ "$output" = "This repeats once.
A unique statement.
End of interlude.
This repeats once." ]
}
