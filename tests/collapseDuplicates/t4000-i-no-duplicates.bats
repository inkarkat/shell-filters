#!/usr/bin/env bats

@test "unique interactive input is not modified" {
    run collapseDuplicates --unbuffered <<-'EOF'
Just some text.
All unique lines.
Seriously.
EOF
    [ "$output" = "Just some text.
All unique lines.
Seriously." ]
}
