#!/usr/bin/env bats

load fixture

@test "only matches and counts are printed to stderr" {
    input="Just some text.
This has foo in it.
All simple lines.
More foooo here.
Seriously."
    run -0 extractMatches --summary-only --to stderr --regexp fo+ --count '\<\w{4}\>' --global --match-count '\<i\w\>' --global <<<"$input"
    assert_output 'extracted matches: here: 6, in: 1, it: 1, foooo'
}
