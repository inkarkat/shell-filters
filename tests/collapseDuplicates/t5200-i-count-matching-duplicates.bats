#!/usr/bin/env bats

load fixture

readonly LF=$'\r'

@test "one interactive matching line is counted" {
    run -0 collapseDuplicates --unbuffered --as count --regexp 'repeat' <<-'EOF'
Just some text.
This will repeat.
This is the repeat.
Seriously.
EOF
    assert_output - <<EOF
Just some text.
This will repeat.${LF}This is the repeat. (2)
Seriously.
EOF
}

@test "three interactive matching lines are counted" {
    run -0 collapseDuplicates --unbuffered --as count --regexp 'repeat' <<-'EOF'
Just some text.
This will repeat.
This is one repeat.
This is another repeat.
This is the third repeat.
Seriously.
EOF
    assert_output - <<EOF
Just some text.
This will repeat.${LF}This is one repeat. (2)${LF}This is another repeat. (3)${LF}This is the third repeat. (4)
Seriously.
EOF
}

@test "interactive match counting of multiple regexps works multiple times" {
    run -0 collapseDuplicates --unbuffered --as count --regexp 'repeat' --regexp '^Not unique\.$' --regexp 'ly.$' <<-'EOF'
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
This will repeat.${LF}This is the repeat. (2)
A unique statement.
Not unique. (2)
Seriously.${LF}Seriously? (2)${LF}Seriously! (3)
EOF
}

@test "interactive match counting of regexp in multiple locations" {
    run -0 collapseDuplicates --unbuffered --as count --regexp 'repeat' <<-'EOF'
This will repeat.
This is the repeat.
That is the last repeat in the first location.
A unique statement.
End of interlude.
Another repeat from what we've seen.
Another repeat yet again.
EOF
    assert_output - <<EOF
This will repeat.${LF}This is the repeat. (2)${LF}That is the last repeat in the first location. (3)
A unique statement.
End of interlude.
Another repeat from what we've seen.${LF}Another repeat yet again. (2)
EOF
}
