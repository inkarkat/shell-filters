#!/usr/bin/env bats

readonly LF=$'\r'

@test "interactive duplicate counting of full line" {
    run collapseDuplicates --unbuffered --as count --match 'repeats .*$' --match '^.*ly\.$' <<-'EOF'
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
Precariously. (2)3)
Seriously." ]
}

@test "interactive duplicate counting of partial match" {
    run collapseDuplicates --unbuffered --as count --match 'repeats' --match 'ly\.$' <<-'EOF'
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
    [ "$output" = "This repeats once.${LF}This repeats here. (2)
A unique statement.
Not unique.
Not unique.
Seriously. (2)${LF}Precariously. (3)4)5)${LF}Seriously. (6)" ]
}
