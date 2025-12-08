#!/usr/bin/env bats

export EXTRACTMATCHES_COUNT_BEFORE_TEXT=t
export EXTRACTMATCHES_COUNT_PREFIX=''
export EXTRACTMATCHES_COUNT_SUFFIX=':'

load title

@test "counts in a line are shown in title before the text" {
    input="Just some text.
This has foo in it.
All simple lines.
More foo here.
Seriously."
    run -0 extractMatches --to title --count fo+ <<<"$input"
    assert_output - <<EOF
Just some text.
This has foo in it.
${R}1:foo${N}All simple lines.
More foo here.
${R}2:foo${N}Seriously.
EOF
}
