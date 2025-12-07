#!/usr/bin/env bats

load fixture

export EXTRACTMATCHES_HIGHLIGHT_PREFIX='['
export EXTRACTMATCHES_HIGHLIGHT_SUFFIX=']'

@test "^ matches just at the start of a line without --global" {
    run -0 extractMatches --regexp '^[a-z]+: ' <<-'EOF'
foo: bar: and baz: quux:
EOF
    assert_output '[foo: ]bar: and baz: quux:'
}

@test "^ matches after the end of a previous match with --global" {
    run -0 extractMatches --regexp '^[a-z]+: ' --global <<-'EOF'
foo: bar: baz: and quux:
EOF
    assert_output '[foo: ][bar: ][baz: ]and quux:'
}
