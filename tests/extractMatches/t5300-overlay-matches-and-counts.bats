#!/usr/bin/env bats

load overlay

@test "matches and counts are overlaid" {
    input="Just some text.
This has foo in it.
All simple lines.
More foooo here.
Seriously."
    run -0 extractMatches --to overlay --regexp fo+ --count '\<\w{4}\>' --global --match-count '\<i\w\>' --global <<<"$input"
    assert_output - <<EOF
Just some text.
${R}text:3${N}This has foo in it.
${R}This:4|in:1|it:1|foo${N}All simple lines.
${R}This:4|in:1|it:1|foo${N}More foooo here.
${R}here:6|in:1|it:1|foooo${N}Seriously.
${R}here:6|in:1|it:1|foooo${N}
EOF
}
