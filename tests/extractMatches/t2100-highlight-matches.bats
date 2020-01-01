#!/usr/bin/env bats

export EXTRACTMATCHES_HIGHLIGHT_PREFIX='['
export EXTRACTMATCHES_HIGHLIGHT_SUFFIX=']'

@test "matches are highlighted" {
    run extractMatches --regexp foo <<-'EOF'
Just some text.
This has foo in it.
All simple lines.
More foo here.
Seriously.
EOF
    [ "$output" = "Just some text.
This has [foo] in it.
All simple lines.
More [foo] here.
Seriously." ]
}
