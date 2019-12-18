#!/usr/bin/env bats

readonly LF=$'\r'

@test "one interactive matching line is counted" {
    run collapseDuplicates --unbuffered --as count --accumulate 'repeat' <<-'EOF'
Just some text.
This will repeat.
This is the repeat.
Seriously.
EOF
    [ "$output" = "Just some text.
This will repeat.${LF}This is the repeat. (2)
Seriously." ]
}

@test "three interactive matching lines are counted" {
    run collapseDuplicates --unbuffered --as count --accumulate 'repeat' <<-'EOF'
Just some text.
This will repeat.
This is one repeat.
This is another repeat.
This is the third repeat.
Seriously.
EOF
    [ "$output" = "Just some text.
This will repeat.${LF}This is one repeat. (2)${LF}This is another repeat. (3)${LF}This is the third repeat. (4)
Seriously." ]
}

@test "interactive match counting of multiple regexps works multiple times" {
    run collapseDuplicates --unbuffered --as count --accumulate 'repeat' --accumulate '^Not unique\.$' --accumulate 'ly.$' <<-'EOF'
This will repeat.
This is the repeat.
A unique statement.
Not unique.
Not unique.
Seriously.
Seriously?
Seriously!
EOF
    [ "$output" = "This will repeat.${LF}This is the repeat. (2)
A unique statement.
Not unique. (2)
Seriously.${LF}Seriously? (2)${LF}Seriously! (3)" ]
}

@test "interactive match counting of accumulate in multiple locations" {
    run collapseDuplicates --unbuffered --as count --accumulate 'repeat' <<-'EOF'
This will repeat.
This is the repeat.
That is the last repeat in the first location.
A unique statement.
End of interlude.
Another repeat from what we've seen.
Another repeat yet again.
EOF
    [ "$output" = "This will repeat.${LF}This is the repeat. (2)${LF}That is the last repeat in the first location. (3)
A unique statement.
End of interlude.
Another repeat from what we've seen. (4)${LF}Another repeat yet again. (5)" ]
}

@test "interactive match counting accumulated also with single line" {
    run collapseDuplicates --unbuffered --as count --accumulate 'repeat' <<-'EOF'
This will repeat.
This is the repeat.
A unique statement.
That is a single repeat in the second location.
End of interlude.
Another repeat in a third location.
Another repeat yet again.
EOF
    [ "$output" = "This will repeat.${LF}This is the repeat. (2)
A unique statement.
That is a single repeat in the second location. (3)
End of interlude.
Another repeat in a third location. (4)${LF}Another repeat yet again. (5)" ]
}

@test "interactive match counting accumulated also starts with single line" {
    run collapseDuplicates --unbuffered --as count --accumulate 'repeat' <<-'EOF'
This repeats once.
A unique statement.
This repeats once.
End of interlude.
This repeats once.
This repeats once.
EOF
    [ "$output" = "This repeats once.
A unique statement.
This repeats once. (2)
End of interlude.
This repeats once. (3)4)" ]
}
