#!/usr/bin/env bats

load fixture

@test "one interactive duplicate line is counted" {
    run -0 collapseDuplicates --unbuffered --as count <<-'EOF'
Just some text.
This repeats once.
This repeats once.
Seriously.
EOF
    assert_output - <<'EOF'
Just some text.
This repeats once. (2)
Seriously.
EOF
}

@test "three interactive duplicate lines are counted" {
    run -0 collapseDuplicates --unbuffered --as count <<-'EOF'
Just some text.
This repeats once.
This repeats once.
This repeats once.
This repeats once.
Seriously.
EOF
    assert_output - <<'EOF'
Just some text.
This repeats once. (2)3)4)
Seriously.
EOF
}

@test "twelve interactive duplicate lines are counted" {
    run -0 collapseDuplicates --unbuffered --as count <<-'EOF'
Just some text.
This repeats once.
This repeats once.
This repeats once.
This repeats once.
This repeats once.
This repeats once.
This repeats once.
This repeats once.
This repeats once.
This repeats once.
This repeats once.
This repeats once.
Seriously.
EOF
    assert_output - <<'EOF'
Just some text.
This repeats once. (2)3)4)5)6)7)8)9)10)11)12)
Seriously.
EOF
}

@test "interactive duplicate counting works multiple times" {
    run -0 collapseDuplicates --unbuffered --as count <<-'EOF'
This repeats once.
This repeats once.
A unique statement.
Not unique.
Not unique.
Seriously.
Seriously.
Seriously.
EOF
    assert_output - <<'EOF'
This repeats once. (2)
A unique statement.
Not unique. (2)
Seriously. (2)3)
EOF
}

@test "interactive duplicate counting in multiple locations" {
    run -0 collapseDuplicates --unbuffered --as count <<-'EOF'
This repeats once.
This repeats once.
This repeats once.
A unique statement.
End of interlude.
This repeats once.
This repeats once.
EOF
    assert_output - <<'EOF'
This repeats once. (2)3)
A unique statement.
End of interlude.
This repeats once. (2)
EOF
}
