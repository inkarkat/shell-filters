#!/usr/bin/env bats

load fixture

@test "counting of all separate / accumulated regexp / matches, " {
    run -0 collapseDuplicates --as count --regexp 'repeat' --accumulate 'sentence' --match '^\w+ly\.$' --match-accumulated '^Not .*$' <<-'EOF'
Some sentence starts it off.
This will occur once more.
This will occur once more.
Seriously.
Seriously.
Precariously.
This will repeat.
This is the repeat.
That is the last repeat in the first location.
A unique statement.
Not unique.
Not unique.
Precariously.
Precariously.
Precariously.
Seriously.
Some sentence in the middle.
Seriously.
Seriously.
Seriously.
End of interlude.
Another repeat from what we've seen.
Another repeat yet again.
Not here.
Some sentence at the end.
EOF
    assert_output - <<'EOF'
Some sentence starts it off.
This will occur once more.
This will occur once more.
Seriously. (2)
Precariously.
This will repeat. (3)
A unique statement.
Not unique. (2)
Precariously. (3)
Seriously.
Some sentence in the middle. (2)
Seriously. (3)
End of interlude.
Another repeat from what we've seen. (2)
Not here.
Some sentence at the end. (3)
EOF
}

@test "counting precedence with match before accumulated matches " {
    run -0 collapseDuplicates --as count --match '^\w+ly\.$' --match-accumulated '^[NST]' <<-'EOF'
Some sentence starts it off.
This will occur once more.
This will occur once more.
Seriously.
Seriously.
Precariously.
This will repeat.
This is the repeat.
That is the last repeat in the first location.
A unique statement.
Not unique.
Not unique.
Precariously.
Precariously.
Precariously.
Seriously.
Some sentence in the middle.
Seriously.
Seriously.
Seriously.
End of interlude.
Another repeat from what we've seen.
Another repeat yet again.
Not here.
Some sentence at the end.
EOF
    assert_output - <<'EOF'
Some sentence starts it off.
This will occur once more. (2)
Seriously. (2)
Precariously.
This will repeat. (5)
A unique statement.
Not unique. (2)
Precariously. (3)
Seriously.
Some sentence in the middle. (2)
Seriously. (3)
End of interlude.
Another repeat from what we've seen.
Another repeat yet again.
Not here. (3)
Some sentence at the end. (3)
EOF
}

@test "counting precedence with accumulated matches before match " {
    run -0 collapseDuplicates --as count --match-accumulated '^[NST]' --match '^\w+ly\.$' <<-'EOF'
Some sentence starts it off.
This will occur once more.
This will occur once more.
Seriously.
Seriously.
Precariously.
This will repeat.
This is the repeat.
That is the last repeat in the first location.
A unique statement.
Not unique.
Not unique.
Precariously.
Precariously.
Precariously.
Seriously.
Some sentence in the middle.
Seriously.
Seriously.
Seriously.
End of interlude.
Another repeat from what we've seen.
Another repeat yet again.
Not here.
Some sentence at the end.
EOF
    assert_output - <<'EOF'
Some sentence starts it off.
This will occur once more. (2)
Seriously. (3)
Precariously.
This will repeat. (5)
A unique statement.
Not unique. (2)
Precariously. (3)
Seriously. (8)
End of interlude.
Another repeat from what we've seen.
Another repeat yet again.
Not here. (3)
Some sentence at the end. (9)
EOF
}

@test "counting precedence with matching vs. exact" {
    run -0 collapseDuplicates --as count --regexp '^[NST]' --match '^\w+ly\.$' <<-'EOF'
Some sentence starts it off.
This will occur once more.
This will occur once more.
Seriously.
Seriously.
Precariously.
This will repeat.
This is the repeat.
That is the last repeat in the first location.
A unique statement.
Not unique.
Not unique.
Precariously.
Precariously.
Precariously.
Seriously.
Some sentence in the middle.
Seriously.
Seriously.
Seriously.
End of interlude.
Another repeat from what we've seen.
Another repeat yet again.
Not here.
Some sentence at the end.
EOF
    assert_output - <<'EOF'
Some sentence starts it off. (5)
Precariously.
This will repeat. (3)
A unique statement.
Not unique. (2)
Precariously. (3)
Seriously. (5)
End of interlude.
Another repeat from what we've seen.
Another repeat yet again.
Not here. (2)
EOF
}

@test "counting precedence with exact vs. matching" {
    run -0 collapseDuplicates --as count --match '^\w+ly\.$' --regexp '^[NST]' <<-'EOF'
Some sentence starts it off.
This will occur once more.
This will occur once more.
Seriously.
Seriously.
Precariously.
This will repeat.
This is the repeat.
That is the last repeat in the first location.
A unique statement.
Not unique.
Not unique.
Precariously.
Precariously.
Precariously.
Seriously.
Some sentence in the middle.
Seriously.
Seriously.
Seriously.
End of interlude.
Another repeat from what we've seen.
Another repeat yet again.
Not here.
Some sentence at the end.
EOF
    assert_output - <<'EOF'
Some sentence starts it off. (3)
Seriously. (2)
Precariously.
This will repeat. (3)
A unique statement.
Not unique. (2)
Precariously. (3)
Seriously.
Some sentence in the middle.
Seriously. (3)
End of interlude.
Another repeat from what we've seen.
Another repeat yet again.
Not here. (2)
EOF
}
