#!/usr/bin/env bats

export EXTRACTMATCHES_HIGHLIGHT_PREFIX='['
export EXTRACTMATCHES_HIGHLIGHT_SUFFIX=']'

@test "matches skipped in whole lines" {
    run extractMatches --regexp fo+ --skip '[[:upper:]]{3,}' --skip '!$' <<-'EOF'
This has foo in it.
foo is SKIPPED everywhere here foo.
Some foo.
foo not counted!
More foo here.
EOF

    [ "$output" = "This has [foo] in it.
foo is SKIPPED everywhere here foo.
Some [foo].
foo not counted!
More [foo] here." ]
}

@test "counting skipped in whole lines" {
    run extractMatches --count fo+ --skip '[[:upper:]]{3,}' --skip '!$' <<-'EOF'
This has foo in it.
foo is SKIPPED everywhere here foo.
Some foo.
foo not counted!
More foo here.
EOF

    [ "$output" = "This has [foo (1)] in it.
foo is SKIPPED everywhere here foo.
Some [foo (2)].
foo not counted!
More [foo (3)] here." ]
}

@test "match-counting skipped in whole lines" {
    run extractMatches --match-count fo+ --skip '[[:upper:]]{3,}' --skip '!$' <<-'EOF'
This has foo in it.
foooo is SKIPPED everywhere here foo.
Some foooo.
foo not counted!
More foooo here.
EOF

    [ "$output" = "This has [foo (1)] in it.
foooo is SKIPPED everywhere here foo.
Some [foooo (1)].
foo not counted!
More [foooo (2)] here." ]
}

@test "resetting skipped in whole lines" {
    run extractMatches --reset-name X --name FOO --count fo+ --global --name FOO --skip '[[:upper:]]{3,}' --skip '!$' <<-'EOF'
This has foo and foo, X, foo in it.
foo is SKIPPED everywhere here foo.
Some X foo.
X not reset!
More foo here.
EOF

    [ "$output" = "This has [foo (1)] and [foo (2)], X, [foo (1)] in it.
foo is SKIPPED everywhere here foo.
Some X [foo (1)].
X not reset!
More [foo (2)] here." ]
}
