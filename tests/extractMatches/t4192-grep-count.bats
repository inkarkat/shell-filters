#!/usr/bin/env bats

load fixture

@test "grep-count is an alias for only a summary of counts to stdout, like grep -c" {
    input="Just some text.
This has foo and foo in it.
More simple lines.
More foooo about it.
Seriously."
    run -0 extractMatches --grep-count --regexp fo+ --global --count "\<[Mm]ore\>" --match-count '\<i\w\>' --global <<<"$input"
    assert_output - <<'EOF'
foo
foo
foooo
More: 2
in: 1
it: 2
EOF
}
