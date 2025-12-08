#!/usr/bin/env bats

load fixture

readonly LF=$'\r'

@test "one interactive matching line is omitted" {
    run -0 collapseDuplicates --unbuffered --regexp 'repeat' <<-'EOF'
Just some text.
This will repeat.
This is the repeat.
Seriously.
EOF
    assert_output - <<EOF
Just some text.
This will repeat.${LF}This is the repeat.
Seriously.
EOF
}

@test "three interactive matching lines are omitted" {
    run -0 collapseDuplicates --unbuffered --regexp 'repeat' <<-'EOF'
Just some text.
This will repeat.
This is one repeat.
This is another repeat.
This is the third repeat.
Seriously.
EOF
    assert_output - <<EOF
Just some text.
This will repeat.${LF}This is one repeat.${LF}This is another repeat.${LF}This is the third repeat.
Seriously.
EOF
}

@test "match interactive suppression of multiple regexps works multiple times" {
    run -0 collapseDuplicates --unbuffered --regexp 'repeat' --regexp '^Not unique\.$' --regexp 'ly.$' <<-'EOF'
This will repeat.
This is the repeat.
A unique statement.
Not unique.
Not unique.
Seriously.
Seriously?
Seriously!
EOF
    assert_output - <<EOF
This will repeat.${LF}This is the repeat.
A unique statement.
Not unique.
Seriously.${LF}Seriously?${LF}Seriously!
EOF
}

@test "match interactive suppression of regexp in multiple locations" {
    run -0 collapseDuplicates --unbuffered --regexp 'repeat' <<-'EOF'
This will repeat.
This is the repeat.
That is the last repeat in the first location.
A unique statement.
End of interlude.
Another repeat from what we've seen.
Another repeat yet again.
EOF
    assert_output - <<EOF
This will repeat.${LF}This is the repeat.${LF}That is the last repeat in the first location.
A unique statement.
End of interlude.
Another repeat from what we've seen.${LF}Another repeat yet again.
EOF
}
