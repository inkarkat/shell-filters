#!/usr/bin/env bats

@test "non-matching input is not modified and returns 1" {
    run extractMatches --regexp foo <<-'EOF'
Just some text.
All simple lines.
Seriously.
EOF
    [ $status -eq 1 ]
    [ "$output" = "Just some text.
All simple lines.
Seriously." ]
}
