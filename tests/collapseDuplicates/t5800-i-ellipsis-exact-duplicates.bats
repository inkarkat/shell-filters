#!/usr/bin/env bats

@test "duplicate interactive ellipsis in multiple locations" {
    run collapseDuplicates --unbuffered --as ellipsis <<-'EOF'
This repeats once.
This repeats once.
This repeats once.
A unique statement.
End of interlude.
This repeats once.
This repeats once.
EOF
    [ "$output" = "This repeats once. [...]
A unique statement.
End of interlude.
This repeats once. [...]" ]
}

@test "duplicate interactive ellipsis single" {
    run collapseDuplicates --unbuffered --as ellipsis <<-'EOF'
This repeats once.
This repeats once.
This repeats once.
A unique statement.
End of interlude.
This repeats once.
One more interlude.
This repeats once.
This repeats once.
EOF
    [ "$output" = "This repeats once. [...]
A unique statement.
End of interlude.
This repeats once.
One more interlude.
This repeats once. [...]" ]
}
