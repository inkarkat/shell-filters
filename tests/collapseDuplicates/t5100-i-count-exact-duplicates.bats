#!/usr/bin/env bats

@test "one interactive duplicate line is counted" {
    run collapseDuplicates --unbuffered --as count <<-'EOF'
Just some text.
This repeats once.
This repeats once.
Seriously.
EOF
    [ "$output" = "Just some text.
This repeats once. (2)
Seriously." ]
}

@test "three interactive duplicate lines are counted" {
    run collapseDuplicates --unbuffered --as count <<-'EOF'
Just some text.
This repeats once.
This repeats once.
This repeats once.
This repeats once.
Seriously.
EOF
    [ "$output" = "Just some text.
This repeats once. (2)3)4)
Seriously." ]
}

@test "twelve interactive duplicate lines are counted" {
    run collapseDuplicates --unbuffered --as count <<-'EOF'
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
    [ "$output" = "Just some text.
This repeats once. (2)3)4)5)6)7)8)9)10)11)12)
Seriously." ]
}

@test "interactive duplicate counting works multiple times" {
    run collapseDuplicates --unbuffered --as count <<-'EOF'
This repeats once.
This repeats once.
A unique statement.
Not unique.
Not unique.
Seriously.
Seriously.
Seriously.
EOF
    [ "$output" = "This repeats once. (2)
A unique statement.
Not unique. (2)
Seriously. (2)3)" ]
}

@test "interactive duplicate counting in multiple locations" {
    run collapseDuplicates --unbuffered --as count <<-'EOF'
This repeats once.
This repeats once.
This repeats once.
A unique statement.
End of interlude.
This repeats once.
This repeats once.
EOF
    [ "$output" = "This repeats once. (2)3)
A unique statement.
End of interlude.
This repeats once. (2)" ]
}
