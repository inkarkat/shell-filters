#!/usr/bin/env bats

load fixture

@test "one matching line is omitted" {
    run -0 collapseDuplicates --regexp 'repeat' <<-'EOF'
Just some text.
This will repeat.
This is the repeat.
Seriously.
EOF
    assert_output - <<'EOF'
Just some text.
This will repeat.
Seriously.
EOF
}

@test "three matching lines are omitted" {
    run -0 collapseDuplicates --regexp 'repeat' <<-'EOF'
Just some text.
This will repeat.
This is one repeat.
This is another repeat.
This is the third repeat.
Seriously.
EOF
    assert_output - <<'EOF'
Just some text.
This will repeat.
Seriously.
EOF
}

@test "match suppression of multiple regexps works multiple times" {
    run -0 collapseDuplicates --regexp 'repeat' --regexp '^Not unique\.$' --regexp 'ly.$' <<-'EOF'
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
This will repeat.
A unique statement.
Not unique.
Seriously.
EOF
}

@test "match suppression of regexp in multiple locations" {
    run -0 collapseDuplicates --regexp 'repeat' <<-'EOF'
This will repeat.
This is the repeat.
That is the last repeat in the first location.
A unique statement.
End of interlude.
Another repeat from what we've seen.
Another repeat yet again.
EOF
    assert_output - <<'EOF'
This will repeat.
A unique statement.
End of interlude.
Another repeat from what we've seen.
EOF
}
