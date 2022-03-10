#!/usr/bin/env bats

load spinner

@test "duplicate interactive spinning in multiple locations" {
    run collapseDuplicates --unbuffered --as spinner <<-'EOF'
This repeats once.
This repeats once.
This repeats once.
This repeats once.
This repeats once.
This repeats once.
This repeats once.
A unique statement.
End of interlude.
This repeats once.
This repeats once.
EOF
    [ "$output" = "This repeats once. /-\\|/-
A unique statement.
End of interlude.
This repeats once. /" ]
}
