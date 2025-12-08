#!/usr/bin/env bats

load fixture

readonly LF=$'\r'

@test "interactive duplicate suppression of full line" {
    run -0 collapseDuplicates --unbuffered --match 'repeats .*$' --match '^.*ly\.$' <<-'EOF'
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
Seriously.
Precariously.
Seriously.
EOF
}

@test "interactive duplicate suppression of partial match" {
    run -0 collapseDuplicates --unbuffered --match 'repeats' --match 'ly\.$' <<-'EOF'
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
This repeats once.${LF}This repeats here.
A unique statement.
Not unique.
Not unique.
Seriously.${LF}Precariously.${LF}Seriously.
EOF
}
