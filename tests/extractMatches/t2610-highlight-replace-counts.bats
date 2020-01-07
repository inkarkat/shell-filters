#!/usr/bin/env bats

export EXTRACTMATCHES_HIGHLIGHT_PREFIX='['
export EXTRACTMATCHES_HIGHLIGHT_SUFFIX=']'

@test "plain replacements of count does not affect counting, only highlighting" {
    run extractMatches --count fo+ --global --replacement "FOO" --count 'i\w' --global --replacement "FOO" <<-'EOF'
This has foo in it.
More fooo here.
EOF
    [ "$output" = "Th[FOO (1)] has [FOO (1)] [FOO (2)] [FOO (3)].
More [FOO (2)] here." ]
}
