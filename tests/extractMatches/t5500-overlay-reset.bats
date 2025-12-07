#!/usr/bin/env bats

load overlay

@test "match resets are overlaid" {
    run -0 extractMatches --to overlay --regexp '\<\w{4}\>' --reset All <<<"$SIMPLE_INPUT"
    assert_output - <<EOF
Just some text.
${R}Just${N}This has foo in it.
${R}This${N}All simple lines.
More foooo here.
${R}More${N}Seriously.
${R}More${N}
EOF
}

@test "count resets are overlaid" {
    run -0 extractMatches --to overlay --count '\<\w{4}\>' --reset All <<<"$SIMPLE_INPUT"
    assert_output - <<EOF
Just some text.
${R}Just:1${N}This has foo in it.
${R}This:2${N}All simple lines.
More foooo here.
${R}More:1${N}Seriously.
${R}More:1${N}
EOF
}

@test "match-count resets are overlaid" {
    run -0 extractMatches --to overlay --match-count '\<\w{4}\>' --reset All <<<"$SIMPLE_INPUT"
    assert_output - <<EOF
Just some text.
${R}Just:1${N}This has foo in it.
${R}Just:1|This:1${N}All simple lines.
More foooo here.
${R}More:1${N}Seriously.
${R}More:1${N}
EOF
}
