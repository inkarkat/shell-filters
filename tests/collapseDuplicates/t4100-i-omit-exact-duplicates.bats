#!/usr/bin/env bats

@test "one interactive duplicate line is omitted" {
    run collapseDuplicates --unbuffered <<-'EOF'
Just some text.
This repeats once.
This repeats once.
Seriously.
EOF
    [ "$output" = "Just some text.
This repeats once.
Seriously." ]
}

@test "three interactive duplicate lines are omitted" {
    run collapseDuplicates --unbuffered <<-'EOF'
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

@test "interactive duplicate suppression works multiple times" {
    run collapseDuplicates --unbuffered <<-'EOF'
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

@test "interactive duplicate suppression in multiple locations" {
    run collapseDuplicates --unbuffered <<-'EOF'
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
