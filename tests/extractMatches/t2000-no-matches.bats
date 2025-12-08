#!/usr/bin/env bats

load fixture

@test "non-matching input is not modified and returns 1" {
    run -1 extractMatches --regexp foo <<-'EOF'
Just some text.
All simple lines.
Seriously.
EOF
    assert_output - <<'EOF'
Just some text.
All simple lines.
Seriously.
EOF
}
