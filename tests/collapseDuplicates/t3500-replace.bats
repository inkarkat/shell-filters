#!/usr/bin/env bats

load fixture

@test "replacement without previous type is not allowed" {
    run -2 collapseDuplicates --as count --replacement 'DUP HERE'
    assert_line -n 0 "Need -e|--regexp|-a|--accumulate|-m|--match|-M|--match-accumulated PATTERN before passing REPLACEMENT."
    assert_line -n 2 -e ^Usage:
}

@test "show plain replacement of one counted duplicate line" {
    run -0 collapseDuplicates --as count --match '.*' --replacement 'DUP HERE' <<-'EOF'
Just some text.
This repeats once.
This repeats once.
Seriously.
EOF
    assert_output - <<'EOF'
Just some text.
DUP HERE (2)
Seriously.
EOF
}

@test "show prefix replacement of three duplicate lines" {
    run -0 collapseDuplicates --as count --match '.*' --replacement 'DUP: &' <<-'EOF'
Just some text.
This repeats once.
This repeats once.
This repeats once.
This repeats once.
Seriously.
EOF
    assert_output - <<'EOF'
Just some text.
DUP: This repeats once. (4)
Seriously.
EOF
}

@test "show capture group replacement in match counting of single regexp" {
    run -0 collapseDuplicates --as count --regexp '^(.*)ly(.)$' --replacement 'I am \1 here\2\2' <<-'EOF'
Unique.
Seriously.
Seriously?
Seriously!
EOF
    assert_output - <<'EOF'
Unique.
I am Serious here.. (3)
EOF
}


@test "show capture group replacement in match counting of multiple regexp" {
    run -0 collapseDuplicates --as count --regexp 'repeat' --replacement '<&>' --regexp '^Not unique\.$' --regexp 'ly(.)$' --replacement '\1' <<-'EOF'
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
This will <repeat>. (2)
A unique statement.
Not unique. (2)
Serious. (3)
EOF
}

@test "plain replacement with nothing" {
    run -0 collapseDuplicates --as count --match '.*' --replacement '' <<-'EOF'
Just some text.
This repeats once.
This repeats once.
Seriously.
EOF
    assert_output - <<'EOF'
Just some text.
(2)
Seriously.
EOF
}
