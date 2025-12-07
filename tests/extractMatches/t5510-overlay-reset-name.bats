#!/usr/bin/env bats

load overlay

@test "match resets by name are overlaid" {

    run -0 extractMatches --to overlay --reset-name All --name fours --regexp '\<\w{4}\>' --name fours <<<"$SIMPLE_INPUT"
    assert_output - <<EOF
Just some text.
${R}Just${N}This has foo in it.
${R}This${N}All simple lines.
More foooo here.
${R}More${N}Seriously.
${R}More${N}
EOF
}

@test "count resets by name are overlaid" {

    run -0 extractMatches --to overlay --reset-name All --name fours --count '\<\w{4}\>' --name fours <<<"$SIMPLE_INPUT"
    assert_output - <<EOF
Just some text.
${R}Just:1${N}This has foo in it.
${R}This:2${N}All simple lines.
More foooo here.
${R}More:1${N}Seriously.
${R}More:1${N}
EOF
}

@test "match-count resets by name are overlaid" {

    run -0 extractMatches --to overlay --reset-name All --name fours --match-count '\<\w{4}\>' --name fours <<<"$SIMPLE_INPUT"
    assert_output - <<EOF
Just some text.
${R}Just:1${N}This has foo in it.
${R}Just:1|This:1${N}All simple lines.
More foooo here.
${R}More:1${N}Seriously.
${R}More:1${N}
EOF
}
