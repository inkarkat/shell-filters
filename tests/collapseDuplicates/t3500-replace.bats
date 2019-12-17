#!/usr/bin/env bats

@test "replacement without previous type is not allowed" {
    run collapseDuplicates --as count --replacement 'DUP HERE'
    [ "${lines[0]}" = "Need -e|--regexp|-a|--accumulate|-m|--match|-M|--match-accumulated PATTERN before passing REPLACEMENT." ]
    [[ "${lines[2]}" =~ ^Usage: ]]
    [ $status -eq 2 ]
}

@test "show plain replacement of one counted duplicate line" {
    run collapseDuplicates --as count --match '.*' --replacement 'DUP HERE' <<-'EOF'
Just some text.
This repeats once.
This repeats once.
Seriously.
EOF
    [ "$output" = "Just some text.
DUP HERE (2)
Seriously." ]
}

@test "show prefix replacement of three duplicate lines" {
    run collapseDuplicates --as count --match '.*' --replacement 'DUP: &' <<-'EOF'
Just some text.
This repeats once.
This repeats once.
This repeats once.
This repeats once.
Seriously.
EOF
    [ "$output" = "Just some text.
DUP: This repeats once. (4)
Seriously." ]
}

@test "show capture group replacement in match counting of single regexp" {
    run collapseDuplicates --as count --regexp '^(.*)ly(.)$' --replacement 'I am \1 here\2\2' <<-'EOF'
Unique.
Seriously.
Seriously?
Seriously!
EOF
    [ "$output" = "Unique.
I am Serious here.. (3)" ]
}


@test "show capture group replacement in match counting of multiple regexp" {
    run collapseDuplicates --as count --regexp 'repeat' --replacement '<&>' --regexp '^Not unique\.$' --regexp 'ly(.)$' --replacement '\1' <<-'EOF'
This will repeat.
This is the repeat.
A unique statement.
Not unique.
Not unique.
Seriously.
Seriously?
Seriously!
EOF
    [ "$output" = "This will <repeat>. (2)
A unique statement.
Not unique. (2)
Serious. (3)" ]
}
