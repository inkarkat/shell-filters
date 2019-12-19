#!/usr/bin/env bats

readonly LF=$'\r'

@test "one interactive matching line is omitted" {
    run collapseDuplicates --unbuffered --regexp 'repeat' <<-'EOF'
Just some text.
This will repeat.
This is the repeat.
Seriously.
EOF
    [ "$output" = "Just some text.
This will repeat.${LF}This is the repeat.
Seriously." ]
}

@test "three interactive matching lines are omitted" {
    run collapseDuplicates --unbuffered --regexp 'repeat' <<-'EOF'
Just some text.
This will repeat.
This is one repeat.
This is another repeat.
This is the third repeat.
Seriously.
EOF
    [ "$output" = "Just some text.
This will repeat.${LF}This is one repeat.${LF}This is another repeat.${LF}This is the third repeat.
Seriously." ]
}

@test "match interactive suppression of multiple regexps works multiple times" {
    run collapseDuplicates --unbuffered --regexp 'repeat' --regexp '^Not unique\.$' --regexp 'ly.$' <<-'EOF'
This will repeat.
This is the repeat.
A unique statement.
Not unique.
Not unique.
Seriously.
Seriously?
Seriously!
EOF
    [ "$output" = "This will repeat.${LF}This is the repeat.
A unique statement.
Not unique.
Seriously.${LF}Seriously?${LF}Seriously!" ]
}

@test "match interactive suppression of regexp in multiple locations" {
    run collapseDuplicates --unbuffered --regexp 'repeat' <<-'EOF'
This will repeat.
This is the repeat.
That is the last repeat in the first location.
A unique statement.
End of interlude.
Another repeat from what we've seen.
Another repeat yet again.
EOF
    [ "$output" = "This will repeat.${LF}This is the repeat.${LF}That is the last repeat in the first location.
A unique statement.
End of interlude.
Another repeat from what we've seen.${LF}Another repeat yet again." ]
}
