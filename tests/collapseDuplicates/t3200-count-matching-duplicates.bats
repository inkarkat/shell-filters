#!/usr/bin/env bats

load fixture

@test "one matching line is counted" {
    run -0 collapseDuplicates --as count --regexp 'repeat' <<-'EOF'
Just some text.
This will repeat.
This is the repeat.
Seriously.
EOF
    assert_output - <<'EOF'
Just some text.
This will repeat. (2)
Seriously.
EOF
}

@test "three matching lines are counted" {
    run -0 collapseDuplicates --as count --regexp 'repeat' <<-'EOF'
Just some text.
This will repeat.
This is one repeat.
This is another repeat.
This is the third repeat.
Seriously.
EOF
    assert_output - <<'EOF'
Just some text.
This will repeat. (4)
Seriously.
EOF
}

@test "match counting of multiple regexps works multiple times" {
    run -0 collapseDuplicates --as count --regexp 'repeat' --regexp '^Not unique\.$' --regexp 'ly.$' <<-'EOF'
This will repeat.
This is the repeat.
A unique statement.
Not unique.
Not unique.
Seriously.
Seriously?
Seriously!
EOF
    assert_output - <<'EOF'
This will repeat. (2)
A unique statement.
Not unique. (2)
Seriously. (3)
EOF
}

@test "match counting of regexp in multiple locations" {
    run -0 collapseDuplicates --as count --regexp 'repeat' <<-'EOF'
This will repeat.
This is the repeat.
That is the last repeat in the first location.
A unique statement.
End of interlude.
Another repeat from what we've seen.
Another repeat yet again.
EOF
    assert_output - <<'EOF'
This will repeat. (3)
A unique statement.
End of interlude.
Another repeat from what we've seen. (2)
EOF
}
