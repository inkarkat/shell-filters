#!/usr/bin/env bats

load fixture

@test "unique interactive input is not modified" {
    run -0 collapseDuplicates --unbuffered <<-'EOF'
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
