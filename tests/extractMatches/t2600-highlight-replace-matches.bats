#!/usr/bin/env bats

export EXTRACTMATCHES_HIGHLIGHT_PREFIX='['
export EXTRACTMATCHES_HIGHLIGHT_SUFFIX=']'

@test "plain replacement of match" {
    run extractMatches --regexp fo+ --replacement "FOO" <<-'EOF'
This has foo in it.
More fooo here.
EOF
    [ "$output" = "This has [FOO] in it.
More [FOO] here." ]
}

@test "prefix replacement of match" {
    run extractMatches --regexp fo+ --replacement "FOO: &" <<-'EOF'
This has foo in it.
More fooo here.
EOF
    [ "$output" = "This has [FOO: foo] in it.
More [FOO: fooo] here." ]
}

@test "capture group replacement of match" {
    run extractMatches --regexp '(f)(o+)' --replacement "\1-\2" <<-'EOF'
This has foo in it.
More fooo here.
EOF
    [ "$output" = "This has [f-oo] in it.
More [f-ooo] here." ]
}
