#!/usr/bin/env bats

load overlay

@test "delayed match is overlaid after delayed counts by default" {
    run extractMatches --to overlay --regexp fo+ --count '\<\w{4}\>' --global --match-count '\<i\w\>' --global <<<"$SIMPLE_INPUT"
    [ "$output" = "Just some text.
${R}text:3${N}This has foo in it.
${R}This:4|in:1|it:1|foo${N}All simple lines.
${R}This:4|in:1|it:1|foo${N}More foooo here.
${R}here:6|in:1|it:1|foooo${N}Seriously.
${R}here:6|in:1|it:1|foooo${N}" ]
}

@test "reconfigured delayed match is overlaid before delayed counts" {
    export EXTRACTMATCHES_MATCH_BEFORE_COUNTS=t
    run extractMatches --to overlay --regexp fo+ --count '\<\w{4}\>' --global --match-count '\<i\w\>' --global <<<"$SIMPLE_INPUT"
    [ "$output" = "Just some text.
${R}text:3${N}This has foo in it.
${R}foo|This:4|in:1|it:1${N}All simple lines.
${R}foo|This:4|in:1|it:1${N}More foooo here.
${R}foooo|here:6|in:1|it:1${N}Seriously.
${R}foooo|here:6|in:1|it:1${N}" ]
}
