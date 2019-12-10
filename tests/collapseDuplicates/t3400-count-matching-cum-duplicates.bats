#!/usr/bin/env bats

@test "one matching line is counted" {
    run collapseDuplicates --as count --accumulate 'repeat' <<-'EOF'
Just some text.
This will repeat.
This is the repeat.
Seriously.
EOF
    [ "$output" = "Just some text.
This will repeat. (2)
Seriously." ]
}

@test "three matching lines are counted" {
    run collapseDuplicates --as count --accumulate 'repeat' <<-'EOF'
Just some text.
This will repeat.
This is one repeat.
This is another repeat.
This is the third repeat.
Seriously.
EOF
    [ "$output" = "Just some text.
This will repeat. (4)
Seriously." ]
}

@test "match counting of multiple regexps works multiple times" {
    run collapseDuplicates --as count --accumulate 'repeat' --accumulate '^Not unique\.$' --accumulate 'ly.$' <<-'EOF'
This will repeat.
This is the repeat.
A unique statement.
Not unique.
Not unique.
Seriously.
Seriously?
Seriously!
EOF
    [ "$output" = "This will repeat. (2)
A unique statement.
Not unique. (2)
Seriously. (3)" ]
}

@test "match counting of accumulate in multiple locations" {
    run collapseDuplicates --as count --accumulate 'repeat' <<-'EOF'
This will repeat.
This is the repeat.
That is the last repeat in the first location.
A unique statement.
End of interlude.
Another repeat from what we've seen.
Another repeat yet again.
EOF
    [ "$output" = "This will repeat. (3)
A unique statement.
End of interlude.
Another repeat from what we've seen. (5)" ]
}

@test "match counting accumulated also with single line" {
    run collapseDuplicates --as count --accumulate 'repeat' <<-'EOF'
This will repeat.
This is the repeat.
A unique statement.
That is a single repeat in the second location.
End of interlude.
Another repeat in a third location.
Another repeat yet again.
EOF
    [ "$output" = "This will repeat. (2)
A unique statement.
That is a single repeat in the second location. (3)
End of interlude.
Another repeat in a third location. (5)" ]
}

@test "match counting accumulated also starts with single line" {
    run collapseDuplicates --as count --accumulate 'repeat' <<-'EOF'
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
This repeats once. (4)" ]
}
