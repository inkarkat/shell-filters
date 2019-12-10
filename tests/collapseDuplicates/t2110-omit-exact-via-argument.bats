#!/usr/bin/env bats

@test "three duplicate lines are omitted via --match argument" {
    run collapseDuplicates --match '.*' <<-'EOF'
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
