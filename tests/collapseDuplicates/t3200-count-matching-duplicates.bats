#!/usr/bin/env bats

@test "one matching line is counted" {
    run collapseDuplicates --as count --regexp 'repeat' <<-'EOF'
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
    run collapseDuplicates --as count --regexp 'repeat' <<-'EOF'
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
    run collapseDuplicates --as count --regexp 'repeat' --regexp '^Not unique\.$' --regexp 'ly.$' <<-'EOF'
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

@test "match counting of regexp in multiple locations" {
    run collapseDuplicates --as count --regexp 'repeat' <<-'EOF'
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
Another repeat from what we've seen. (2)" ]
}
