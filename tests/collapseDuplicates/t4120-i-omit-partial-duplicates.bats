#!/usr/bin/env bats

readonly LF=$'\r'

@test "interactive duplicate suppression of full line" {
    run collapseDuplicates --unbuffered --match 'repeats .*$' --match '^.*ly\.$' <<-'EOF'
This repeats once.
This repeats here.
A unique statement.
Not unique.
Not unique.
Seriously.
Seriously.
Precariously.
Precariously.
Precariously.
Seriously.
EOF
    [ "$output" = "This repeats once.
This repeats here.
A unique statement.
Not unique.
Not unique.
Seriously.
Precariously.
Seriously." ]
}

@test "interactive duplicate suppression of partial match" {
    run collapseDuplicates --unbuffered --match 'repeats' --match 'ly\.$' <<-'EOF'
This repeats once.
This repeats here.
A unique statement.
Not unique.
Not unique.
Seriously.
Seriously.
Precariously.
Precariously.
Precariously.
Seriously.
EOF
    [ "$output" = "This repeats once.${LF}This repeats here.
A unique statement.
Not unique.
Not unique.
Seriously.${LF}Precariously.${LF}Seriously." ]
}
