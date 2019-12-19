#!/usr/bin/env bats

@test "duplicate counting of full line" {
    run collapseDuplicates --as count --match 'repeats .*$' --match '^.*ly\.$' <<-'EOF'
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
Seriously. (2)
Precariously. (3)
Seriously." ]
}

@test "duplicate counting of partial match" {
    run collapseDuplicates --as count --match 'repeats' --match 'ly\.$' <<-'EOF'
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
    [ "$output" = "This repeats once. (2)
A unique statement.
Not unique.
Not unique.
Seriously. (6)" ]
}
