#!/usr/bin/env bats

export EXTRACTMATCHES_HIGHLIGHT_PREFIX='['
export EXTRACTMATCHES_HIGHLIGHT_SUFFIX=']'

@test "single matches in a line are highlighted" {
    run extractMatches --regexp fo+ <<-'EOF'
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

@test "only the first match in a line is highlighted" {
    run extractMatches --regexp fo+ <<-'EOF'
This has foo, foo and foofoo in it.
More foooo and foo here.
EOF
    [ "$output" = "This has [foo], foo and foofoo in it.
More [foooo] and foo here." ]
}

@test "all matches in a line are highlighted with --global" {
    run extractMatches --regexp fo+ --global <<-'EOF'
This has foo, foo and foofoo in it.
More foooo and foo here.
EOF
    [ "$output" = "This has [foo], [foo] and [foo][foo] in it.
More [foooo] and [foo] here." ]
}
