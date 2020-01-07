#!/usr/bin/env bats

@test "non-matching input is not modified" {
    run extractMatches --regexp foo <<-'EOF'
Just some text.
All simple lines.
Seriously.
EOF
    [ "$output" = "Just some text.
All simple lines.
Seriously." ]
}
