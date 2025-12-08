#!/usr/bin/env bats

load title

@test "match resets are shown in title" {
    run -0 extractMatches --to title --regexp '\<\w{4}\>' --reset All <<<"$SIMPLE_INPUT"
    assert_output - <<EOF
Just some text.
${R}Just${N}This has foo in it.
${R}This${N}All simple lines.
More foooo here.
${R}More${N}Seriously.
EOF
}

@test "count resets are shown in title" {
    run -0 extractMatches --to title --count '\<\w{4}\>' --reset All <<<"$SIMPLE_INPUT"
    assert_output - <<EOF
Just some text.
${R}Just:1${N}This has foo in it.
${R}This:2${N}All simple lines.
More foooo here.
${R}More:1${N}Seriously.
EOF
}

@test "match-count resets are shown in title" {
    run -0 extractMatches --to title --match-count '\<\w{4}\>' --reset All <<<"$SIMPLE_INPUT"
    assert_output - <<EOF
Just some text.
${R}Just:1${N}This has foo in it.
${R}Just:1|This:1${N}All simple lines.
More foooo here.
${R}More:1${N}Seriously.
EOF
}
