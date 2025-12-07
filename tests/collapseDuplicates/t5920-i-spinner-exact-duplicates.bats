#!/usr/bin/env bats

load spinner

@test "duplicate interactive spinning in multiple locations" {
    run -0 collapseDuplicates --unbuffered --as spinner <<-'EOF'
This repeats once.
This repeats once.
This repeats once.
This repeats once.
This repeats once.
This repeats once.
This repeats once.
A unique statement.
End of interlude.
This repeats once.
This repeats once.
EOF
    assert_output - <<'EOF'
This repeats once. /-\|/-
A unique statement.
End of interlude.
This repeats once. /
EOF
}

@test "custom 3-part application-specific spinner" {
    export COLLAPSEDUPLICATES_SPINNER='ABC'
    run -0 collapseDuplicates --unbuffered --as spinner <<-'EOF'
This repeats once.
This repeats once.
This repeats once.
This repeats once.
This repeats once.
This repeats once.
This repeats once.
EOF
    assert_output 'This repeats once. ABCABC'
}

@test "custom 2-part generic spinner" {
    export SPINNER='▌▐'
    run -0 collapseDuplicates --unbuffered --as spinner <<-'EOF'
This repeats once.
This repeats once.
This repeats once.
This repeats once.
This repeats once.
This repeats once.
This repeats once.
EOF
    assert_output 'This repeats once. ▌▐▌▐▌▐'
}
