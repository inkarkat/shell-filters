#!/usr/bin/env bats

export EXTRACTMATCHES_HIGHLIGHT_PREFIX='['
export EXTRACTMATCHES_HIGHLIGHT_SUFFIX=']'
export EXTRACTMATCHES_COUNT_BEFORE_TEXT=t
export EXTRACTMATCHES_COUNT_PREFIX=''
export EXTRACTMATCHES_COUNT_SUFFIX=':'

@test "counts in a line are highlighted before the text" {
    run extractMatches --count fo+ <<-'EOF'
Just some text.
This has foo in it.
All simple lines.
More foo here.
Seriously.
EOF
    [ "$output" = "Just some text.
This has [1:foo] in it.
All simple lines.
More [2:foo] here.
Seriously." ]
}
