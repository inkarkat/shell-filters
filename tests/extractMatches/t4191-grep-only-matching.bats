#!/usr/bin/env bats

@test "grep-only-matching is an alias for immediately writing only matches to stdout, like grep -o" {
    input="Just some text.
This has foo and foo in it.
More simple lines.
More foooo about it.
Seriously."
    run extractMatches --grep-only-matching --regexp fo+ --global --regexp "\<[Mm]ore\>" --match-count '\<i\w\>' --global <<<"$input"
    [ "$output" = "foo
foo
in: 1
it: 1
More
More
foooo
it: 2" ]
}
