#!/usr/bin/env bats

load fixture

readonly LF=$'\r'

@test "interactive duplicate counting of full line" {
    run -0 collapseDuplicates --unbuffered --as count --match 'repeats .*$' --match '^.*ly\.$' <<-'EOF'
This repeats once.
This repeats here.
A unique statement.
Not unique.
Not unique.
Seriously.
Seriously.
Precariously.
Precariously.
Precariously.
Seriously.
EOF
    assert_output - <<'EOF'
This repeats once.
This repeats here.
A unique statement.
Not unique.
Not unique.
Seriously. (2)
Precariously. (2)3)
Seriously.
EOF
}

@test "interactive duplicate counting of partial match" {
    run -0 collapseDuplicates --unbuffered --as count --match 'repeats' --match 'ly\.$' <<-'EOF'
This repeats once.
This repeats here.
A unique statement.
Not unique.
Not unique.
Seriously.
Seriously.
Precariously.
Precariously.
Precariously.
Seriously.
EOF
    assert_output - <<EOF
This repeats once.${LF}This repeats here. (2)
A unique statement.
Not unique.
Not unique.
Seriously. (2)${LF}Precariously. (3)4)5)${LF}Seriously. (6)
EOF
}
