#!/usr/bin/env bats

export EXTRACTMATCHES_HIGHLIGHT_PREFIX='['
export EXTRACTMATCHES_HIGHLIGHT_SUFFIX=']'

@test "^ matches just at the start of a line without --global" {
    run extractMatches --regexp '^[a-z]+: ' <<-'EOF'
foo: bar: and baz: quux:
EOF
    [ $status -eq 0 ]
    [ "$output" = "[foo: ]bar: and baz: quux:" ]
}

@test "^ matches after the end of a previous match with --global" {
    run extractMatches --regexp '^[a-z]+: ' --global <<-'EOF'
foo: bar: baz: and quux:
EOF
    [ $status -eq 0 ]
    [ "$output" = "[foo: ][bar: ][baz: ]and quux:" ]
}
