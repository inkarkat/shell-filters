#!/usr/bin/env bats

@test "matches and counts are printed to stderr at the end" {
    input="Just some text.
This has foo in it.
All simple lines.
More foooo here.
Seriously."
    run extractMatches --unbuffered --summary-only --to stderr --regexp fo+ --count '\<\w{4}\>' --global --match-count '\<i\w\>' --global <<<"$input"
    [ "$output" = "Just some text.
This has foo in it.
All simple lines.
More foooo here.
Seriously.
extracted matches: here: 6, in: 1, it: 1, foooo" ]
}
