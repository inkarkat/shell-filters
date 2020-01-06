#!/usr/bin/env bats

load overlay

@test "match resets are overlaid" {
    run extractMatches --to overlay --regexp '\<\w{4}\>' --reset All <<<"$SIMPLE_INPUT"
    [ "$output" = "Just some text.
${R}Just${N}This has foo in it.
${R}This${N}All simple lines.
More foooo here.
${R}More${N}Seriously.
${R}More${N}" ]
}

@test "count resets are overlaid" {
    run extractMatches --to overlay --count '\<\w{4}\>' --reset All <<<"$SIMPLE_INPUT"
    [ "$output" = "Just some text.
${R}Just:1${N}This has foo in it.
${R}This:2${N}All simple lines.
More foooo here.
${R}More:1${N}Seriously.
${R}More:1${N}" ]
}

@test "match-count resets are overlaid" {
    run extractMatches --to overlay --match-count '\<\w{4}\>' --reset All <<<"$SIMPLE_INPUT"
    [ "$output" = "Just some text.
${R}Just:1${N}This has foo in it.
${R}Just:1|This:1${N}All simple lines.
More foooo here.
${R}More:1${N}Seriously.
${R}More:1${N}" ]
}
