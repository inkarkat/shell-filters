#!/usr/bin/env bats

@test "duplicate interactive dotting in multiple locations" {
    run collapseDuplicates --unbuffered --as dot <<-'EOF'
This repeats once.
This repeats once.
This repeats once.
A unique statement.
End of interlude.
This repeats once.
This repeats once.
EOF
    [ "$output" = "This repeats once...
A unique statement.
End of interlude.
This repeats once.." ]
}
