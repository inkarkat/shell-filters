#!/usr/bin/env bats

load title

@test "matches and counts are shown in title" {
    input="Just some text.
This has foo in it.
All simple lines.
More foooo here.
Seriously."
    run extractMatches --to title --regexp fo+ --count '\<\w{4}\>' --global --match-count '\<i\w\>' --global <<<"$input"
    [ "$output" = "Just some text.
${R}text:3${N}This has foo in it.
${R}This:4|in:1|it:1|foo${N}All simple lines.
${R}This:4|in:1|it:1|foo${N}More foooo here.
${R}here:6|in:1|it:1|foooo${N}Seriously.
${R}here:6|in:1|it:1|foooo${N}" ]
}
