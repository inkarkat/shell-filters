#!/usr/bin/env bats

export EXTRACTMATCHES_HIGHLIGHT_PREFIX='['
export EXTRACTMATCHES_HIGHLIGHT_SUFFIX=']'

@test "plain replacements of matches affects counting and highlighting" {
    run extractMatches --matches fo+ --replacement "FOO" <<-'EOF'
This has foo in it.
More fooo here.
EOF
    [ "$output" = "This has [FOO] in it.
More [FOO] here." ]
}

@test "capture group replacements of matches that condense characters affects counting and highlighting" {
    run extractMatches --matches '([fm])(o)+' --global --replacement "\1\2" <<-'EOF'
This moooo mooo moo has foo in it.
More fooo here. moooo moo
EOF
    [ "$output" = "This [mo] [mo] [mo] has [fo] in it.
More [fo] here. [mo] [mo]" ]
}
