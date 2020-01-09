#!/usr/bin/env bats

load overlay

@test "in quiet mode, only matches and counts are overlaid" {
    input="Just some text.
This has foo in it.
All simple lines.
More foooo here.
Seriously."
    run extractMatches --quiet --to overlay --regexp fo+ --count '\<\w{4}\>' --global --match-count '\<i\w\>' --global <<<"$input"
    [ "$output" = "${R}text:3${N}${R}This:4|in:1|it:1|foo${N}${R}This:4|in:1|it:1|foo${N}${R}here:6|in:1|it:1|foooo${N}${R}here:6|in:1|it:1|foooo${N}" ]
}
