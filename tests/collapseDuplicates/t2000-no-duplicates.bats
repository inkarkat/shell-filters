#!/usr/bin/env bats

load fixture

@test "unique input is not modified" {
    run -0 collapseDuplicates <<-'EOF'
Just some text.
All unique lines.
Seriously.
EOF
    assert_output - <<'EOF'
Just some text.
All unique lines.
Seriously.
EOF
}
