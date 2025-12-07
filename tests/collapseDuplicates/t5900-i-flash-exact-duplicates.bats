#!/usr/bin/env bats

load fixture

readonly R='[07m'
readonly N='[0m'
readonly LF=$'\r'

@test "duplicate interactive flash in multiple locations" {
    run -0 collapseDuplicates --unbuffered --as flash <<-'EOF'
This repeats once.
This repeats once.
This repeats once.
A unique statement.
End of interlude.
This repeats once.
This repeats once.
EOF
    assert_output - <<EOF
This repeats once.${LF}${R}This repeats once.${N}${LF}This repeats once.${LF}${R}This repeats once.${N}${LF}This repeats once.
A unique statement.
End of interlude.
This repeats once.${LF}${R}This repeats once.${N}${LF}This repeats once.
EOF
}

@test "duplicate interactive flash single" {
    run -0 collapseDuplicates --unbuffered --as flash <<-'EOF'
This repeats once.
This repeats once.
This repeats once.
A unique statement.
End of interlude.
This repeats once.
One more interlude.
This repeats once.
This repeats once.
EOF
    assert_output - <<EOF
This repeats once.${LF}${R}This repeats once.${N}${LF}This repeats once.${LF}${R}This repeats once.${N}${LF}This repeats once.
A unique statement.
End of interlude.
This repeats once.
One more interlude.
This repeats once.${LF}${R}This repeats once.${N}${LF}This repeats once.
EOF
}
