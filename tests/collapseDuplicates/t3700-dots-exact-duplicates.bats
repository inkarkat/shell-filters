#!/usr/bin/env bats

load fixture

@test "duplicate dotting in multiple locations" {
    run -0 collapseDuplicates --as dot <<-'EOF'
This repeats once.
This repeats once.
This repeats once.
A unique statement.
End of interlude.
This repeats once.
This repeats once.
EOF
    assert_output - <<'EOF'
This repeats once...
A unique statement.
End of interlude.
This repeats once..
EOF
}
