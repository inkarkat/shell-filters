#!/usr/bin/env bats

@test "unique input is not modified" {
    run collapseDuplicates <<-'EOF'
Just some text.
All unique lines.
Seriously.
EOF
    [ "$output" = "Just some text.
All unique lines.
Seriously." ]
}
