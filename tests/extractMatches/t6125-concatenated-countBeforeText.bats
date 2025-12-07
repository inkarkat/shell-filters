#!/usr/bin/env bats

load fixture

export EXTRACTMATCHES_COUNT_BEFORE_TEXT=t
export EXTRACTMATCHES_COUNT_PREFIX=''
export EXTRACTMATCHES_COUNT_SUFFIX=':'

@test "counts in a line are shown in concatenated line before the text" {
    input="Just some text.
This has foo in it.
All simple lines.
More foo here.
Seriously."
    run -0 extractMatches --to concatenated --count fo+ <<<"$input"
    assert_output - <<'EOF'
Just some text.
This has foo in it.
extracted matches: 1:foo
All simple lines.
More foo here.
extracted matches: 2:foo
Seriously.
EOF
}
