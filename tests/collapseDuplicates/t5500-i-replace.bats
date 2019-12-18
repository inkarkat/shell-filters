#!/usr/bin/env bats

readonly LF=$'\r'

@test "show interactive plain replacement of one counted duplicate line" {
    run collapseDuplicates --unbuffered --as count --match '.*' --replacement 'DUP HERE' <<-'EOF'
Just some text.
This repeats once.
This repeats once.
Seriously.
EOF
    [ "$output" = "Just some text.
This repeats once.${LF}DUP HERE (2)
Seriously." ]
}

@test "show interactive prefix replacement of three duplicate lines" {
    run collapseDuplicates --unbuffered --as count --match '.*' --replacement 'DUP: &' <<-'EOF'
Just some text.
This repeats once.
This repeats once.
This repeats once.
This repeats once.
Seriously.
EOF
    [ "$output" = "Just some text.
This repeats once.${LF}DUP: This repeats once. (2)${LF}DUP: This repeats once. (3)${LF}DUP: This repeats once. (4)
Seriously." ]
}

@test "show interactive capture group replacement in match counting of single regexp" {
    run collapseDuplicates --unbuffered --as count --regexp '^(.*)ly(.)$' --replacement 'I am \1 here\2\2' <<-'EOF'
Unique.
Seriously.
Seriously?
Seriously!
EOF
    [ "$output" = "Unique.
Seriously.${LF}I am Serious here?? (2)${LF}I am Serious here!! (3)" ]
}


@test "show interactive capture group replacement in match counting of multiple regexp" {
    run collapseDuplicates --unbuffered --as count --regexp 'repeat' --replacement '<&>' --regexp '^Not unique\.$' --regexp 'ly(.)$' --replacement '\1' <<-'EOF'
This will repeat.
This is the repeat.
A unique statement.
Not unique.
Not unique.
Seriously.
Seriously?
Seriously!
EOF
    [ "$output" = "This will repeat.${LF}This is the <repeat>. (2)
A unique statement.
Not unique. (2)
Seriously.${LF}Serious? (2)${LF}Serious! (3)" ]
}
