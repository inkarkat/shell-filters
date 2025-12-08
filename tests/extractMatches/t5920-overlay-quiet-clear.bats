#!/usr/bin/env bats

load overlay

readonly RQ='[1G['
readonly NQ='][0K'

@test "single matches in a line are quietly overlaid in-line and finally cleared" {
    input="Just some text.
This has foo in it.
All simple lines.
More foooo here.
Seriously."
    run -0 extractMatches --to overlay --clear --quiet --regexp fo+ --count '\<\w{4}\>' --global --match-count '\<i\w\>' --global <<<"$input"
    assert_output "${RQ}text:3${NQ}${RQ}This:4|in:1|it:1|foo${NQ}${RQ}This:4|in:1|it:1|foo${NQ}${RQ}here:6|in:1|it:1|foooo${NQ}${RQ}here:6|in:1|it:1|foooo${NQ}[1G[0K"
}

@test "no matches do not clear non-existing overlay" {
    input="Just some text.
Seriously."
    run -1 extractMatches --to overlay --clear --quiet --regexp fo+ <<<"$input"
    assert_output ''
}
