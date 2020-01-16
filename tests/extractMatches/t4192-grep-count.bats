#!/usr/bin/env bats

@test "grep-count is an alias for only a summary of counts to stdout, like grep -c" {
    input="Just some text.
This has foo and foo in it.
More simple lines.
More foooo about it.
Seriously."
    run extractMatches --grep-count --regexp fo+ --global --count "\<[Mm]ore\>" --match-count '\<i\w\>' --global <<<"$input"
    [ "$output" = "foo
foo
foooo
More: 2
in: 1
it: 2" ]
}
