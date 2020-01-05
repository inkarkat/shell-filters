#!/usr/bin/env bats

load title

@test "match resets by name are shown in title" {

    run extractMatches --to title --reset-name All --name fours --regexp '\<\w{4}\>' --name fours <<<"$SIMPLE_INPUT"
    [ "$output" = "Just some text.
${R}Just${N}This has foo in it.
${R}This${N}All simple lines.
More foooo here.
${R}More${N}Seriously.
${R}More${N}" ]
}

@test "count resets by name are shown in title" {

    run extractMatches --to title --reset-name All --name fours --count '\<\w{4}\>' --name fours <<<"$SIMPLE_INPUT"
    [ "$output" = "Just some text.
${R}Just:1${N}This has foo in it.
${R}This:2${N}All simple lines.
More foooo here.
${R}More:1${N}Seriously.
${R}More:1${N}" ]
}

@test "match-count resets by name are shown in title" {

    run extractMatches --to title --reset-name All --name fours --match-count '\<\w{4}\>' --name fours <<<"$SIMPLE_INPUT"
    [ "$output" = "Just some text.
${R}Just:1${N}This has foo in it.
${R}Just:1|This:1${N}All simple lines.
More foooo here.
${R}More:1${N}Seriously.
${R}More:1${N}" ]
}
