#!/usr/bin/env bats

export EXTRACTMATCHES_HIGHLIGHT_PREFIX='['
export EXTRACTMATCHES_HIGHLIGHT_SUFFIX=']'

@test "plain replacements of match-count affects counting and highlighting" {
    run extractMatches --match-count fo+ --replacement "FOO" <<-'EOF'
This has foo in it.
More fooo here.
EOF
    [ "$output" = "This has [FOO (1)] in it.
More [FOO (2)] here." ]
}

@test "capture group replacements of match-count that condense characters affects counting and highlighting" {
    run extractMatches --match-count '([fm])(o)+' --global --replacement "\1\2" <<-'EOF'
This moooo mooo moo has foo in it.
More fooo here. moooo moo
EOF
    [ "$output" = "This [mo (1)] [mo (2)] [mo (3)] has [fo (1)] in it.
More [fo (2)] here. [mo (4)] [mo (5)]" ]
}
