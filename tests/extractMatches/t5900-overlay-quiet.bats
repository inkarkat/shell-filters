#!/usr/bin/env bats

load overlay

readonly RQ='[1G['
readonly NQ='][0K'

@test "in quiet mode the cursor just moves to start of line, clears after it, and no default highlighting" {
    input="Just some text.
This has foo in it.
All simple lines.
More foooo here.
Seriously."
    run -0 extractMatches --quiet --to overlay --regexp fo+ --count '\<\w{4}\>' --global --match-count '\<i\w\>' --global <<<"$input"
    assert_output "${RQ}text:3${NQ}${RQ}This:4|in:1|it:1|foo${NQ}${RQ}This:4|in:1|it:1|foo${NQ}${RQ}here:6|in:1|it:1|foooo${NQ}${RQ}here:6|in:1|it:1|foooo${NQ}"
}
