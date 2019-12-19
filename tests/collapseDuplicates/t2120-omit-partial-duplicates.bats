#!/usr/bin/env bats

@test "duplicate suppression of full line" {
    run collapseDuplicates --match 'repeats .*$' --match '^.*ly\.$' <<-'EOF'
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

@test "duplicate suppression of partial match" {
    run collapseDuplicates --match 'repeats' --match 'ly\.$' <<-'EOF'
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
A unique statement.
Not unique.
Not unique.
Seriously." ]
}
