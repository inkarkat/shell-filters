#!/usr/bin/env bats

load fixture

@test "duplicate counting of full line" {
    run -0 collapseDuplicates --as count --match 'repeats .*$' --match '^.*ly\.$' <<-'EOF'
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
Precariously. (3)
Seriously.
EOF
}

@test "duplicate counting of partial match" {
    run -0 collapseDuplicates --as count --match 'repeats' --match 'ly\.$' <<-'EOF'
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
This repeats once. (2)
A unique statement.
Not unique.
Not unique.
Seriously. (6)
EOF
}
