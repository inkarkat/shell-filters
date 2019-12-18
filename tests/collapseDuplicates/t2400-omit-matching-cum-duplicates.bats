#!/usr/bin/env bats

@test "one matching line is omitted" {
    run collapseDuplicates --accumulate 'repeat' <<-'EOF'
Just some text.
This will repeat.
This is the repeat.
Seriously.
EOF
    [ "$output" = "Just some text.
This will repeat.
Seriously." ]
}

@test "three matching lines are omitted" {
    run collapseDuplicates --accumulate 'repeat' <<-'EOF'
Just some text.
This will repeat.
This is one repeat.
This is another repeat.
This is the third repeat.
Seriously.
EOF
    [ "$output" = "Just some text.
This will repeat.
Seriously." ]
}

@test "match suppression of multiple regexps works multiple times" {
    run collapseDuplicates --accumulate 'repeat' --accumulate '^Not unique\.$' --accumulate 'ly.$' <<-'EOF'
This will repeat.
This is the repeat.
A unique statement.
Not unique.
Not unique.
Seriously.
Seriously?
Seriously!
EOF
    [ "$output" = "This will repeat.
A unique statement.
Not unique.
Seriously." ]
}

@test "match suppression of accumulate in multiple locations" {
    run collapseDuplicates --accumulate 'repeat' <<-'EOF'
This will repeat.
This is the repeat.
That is the last repeat in the first location.
A unique statement.
End of interlude.
Another repeat from what we've seen.
Another repeat yet again.
EOF
    [ "$output" = "This will repeat.
A unique statement.
End of interlude.
Another repeat from what we've seen." ]
}
