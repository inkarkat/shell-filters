#!/usr/bin/env bats

load fixture

@test "in quiet mode, only matches and counts are shown in concatenated line" {
    input="Just some text.
This has foo in it.
All simple lines.
More foooo here.
Seriously."
    run -0 extractMatches --quiet --to concatenated --regexp fo+ --count '\<\w{4}\>' --global --match-count '\<i\w\>' --global <<<"$input"
    assert_output - <<'EOF'
extracted matches: text: 3
extracted matches: This: 4, in: 1, it: 1, foo
extracted matches: here: 6, in: 1, it: 1, foooo
EOF
}
