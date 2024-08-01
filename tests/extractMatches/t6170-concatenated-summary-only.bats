#!/usr/bin/env bats

@test "only the last regexp match and counts are shown in concatenated line" {
    input="Just some text.
This has foo in it.
All simple lines.
More foooo here.
Seriously."
    run extractMatches --summary-only --to concatenated --regexp fo+ --count '\<\w{4}\>' --global --match-count '\<i\w\>' --global <<<"$input"
    [ "$output" = "extracted matches: here: 6, in: 1, it: 1, foooo" ]
}

@test "only the last regexp match, matches and counts are shown in concatenated line" {
    input="Just some text.
This boo has foo in it.
All simple boo and bo and boooo.
More foooo here.
Seriously."
    run extractMatches --summary-only --to concatenated --regexp fo+ --count '\<\w{4}\>' --global --matches bo+ --global --match-count '\<i\w\>' --global <<<"$input"
    [ "$output" = "extracted matches: here: 6, bo, boo, boooo, in: 1, it: 1, foooo" ]
}
