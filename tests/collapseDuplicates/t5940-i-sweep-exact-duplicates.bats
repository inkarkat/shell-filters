#!/usr/bin/env bats

@test "duplicate interactive sweeping in multiple locations" {
    run collapseDuplicates --unbuffered --as sweep <<-'EOF'
This repeats once.
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
    [ "$output" = "This repeats once. [...] ..]. .].. ]. .] ..]. .]
A unique statement.
End of interlude.
This repeats once. [...]" ]
}
