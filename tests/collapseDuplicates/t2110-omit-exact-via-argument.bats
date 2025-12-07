#!/usr/bin/env bats

load fixture

@test "three duplicate lines are omitted via --match argument" {
    run -0 collapseDuplicates --match '.*' <<-'EOF'
Just some text.
This repeats once.
This repeats once.
This repeats once.
This repeats once.
Seriously.
EOF
    assert_output - <<'EOF'
Just some text.
This repeats once.
Seriously.
EOF
}
