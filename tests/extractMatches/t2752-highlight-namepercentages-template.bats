#!/usr/bin/env bats

export EXTRACTMATCHES_HIGHLIGHT_PREFIX='['
export EXTRACTMATCHES_HIGHLIGHT_SUFFIX=']'

@test "percentages with overridden template" {
    export EXTRACTMATCHES_NAME_PERCENTAGES_TEMPLATE='\2%/\1'
    run extractMatches --match-count fo+ --global --name foos --name-percentages foos <<-'EOF'
Or some sexy text.
This text has foo, or foooo and foofoo in it.
All more simple text.
And more foo text here.
Or fooo text.
EOF
    [ "$output" = "Or some sexy text.
This text has [foo (100%/1)], or [foooo (50%/1)] and [foo (67%/2)][foo (75%/3)] in it.
All more simple text.
And more [foo (80%/4)] text here.
Or [fooo (17%/1)] text." ]
}
