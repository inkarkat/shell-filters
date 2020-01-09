#!/usr/bin/env bats

@test "in quiet mode, only matches and counts are shown in concatenated line" {
    input="Just some text.
This has foo in it.
All simple lines.
More foooo here.
Seriously."
    run extractMatches --quiet --to concatenated --regexp fo+ --count '\<\w{4}\>' --global --match-count '\<i\w\>' --global <<<"$input"
    [ "$output" = "extracted matches: text: 3
extracted matches: This: 4, in: 1, it: 1, foo
extracted matches: here: 6, in: 1, it: 1, foooo" ]
}
