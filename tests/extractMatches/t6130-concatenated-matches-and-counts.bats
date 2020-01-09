#!/usr/bin/env bats

@test "matches and counts are shown in concatenated line" {
    input="Just some text.
This has foo in it.
All simple lines.
More foooo here.
Seriously."
    run extractMatches --to concatenated --regexp fo+ --count '\<\w{4}\>' --global --match-count '\<i\w\>' --global <<<"$input"
    [ "$output" = "Just some text.
extracted matches: text: 3
This has foo in it.
extracted matches: This: 4, in: 1, it: 1, foo
All simple lines.
More foooo here.
extracted matches: here: 6, in: 1, it: 1, foooo
Seriously." ]
}
