#!/usr/bin/env bats

load fixture

export EXTRACTMATCHES_HIGHLIGHT_PREFIX='['
export EXTRACTMATCHES_HIGHLIGHT_SUFFIX=']'

@test "plain replacements of matches affects counting and highlighting" {
    run -0 extractMatches --matches fo+ --replacement "FOO" <<-'EOF'
This has foo in it.
More fooo here.
EOF
    assert_output - <<'EOF'
This has [FOO] in it.
More [FOO] here.
EOF
}

@test "capture group replacements of matches that condense characters affects counting and highlighting" {
    run -0 extractMatches --matches '([fm])(o)+' --global --replacement "\1\2" <<-'EOF'
This moooo mooo moo has foo in it.
More fooo here. moooo moo
EOF
    assert_output - <<'EOF'
This [mo] [mo] [mo] has [fo] in it.
More [fo] here. [mo] [mo]
EOF
}
