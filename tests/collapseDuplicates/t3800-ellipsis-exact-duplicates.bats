#!/usr/bin/env bats

@test "duplicate ellipsis in multiple locations" {
    run collapseDuplicates --as ellipsis <<-'EOF'
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
