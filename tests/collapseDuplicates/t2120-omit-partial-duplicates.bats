#!/usr/bin/env bats

load fixture

@test "duplicate suppression of full line" {
    run -0 collapseDuplicates --match 'repeats .*$' --match '^.*ly\.$' <<-'EOF'
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

@test "duplicate suppression of partial match" {
    run -0 collapseDuplicates --match 'repeats' --match 'ly\.$' <<-'EOF'
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
A unique statement.
Not unique.
Not unique.
Seriously.
EOF
}
