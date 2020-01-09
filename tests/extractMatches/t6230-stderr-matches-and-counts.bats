#!/usr/bin/env bats

load log

@test "matches and counts are printed to stderr" {
    input="Just some text.
This has foo in it.
All simple lines.
More foooo here.
Seriously."
    extractMatches --unbuffered --to stderr --regexp fo+ --count '\<\w{4}\>' --global --match-count '\<i\w\>' --global <<<"$input" 2> "$LOG"
    assert_log "extracted matches: text: 3
extracted matches: This: 4, in: 1, it: 1, foo
extracted matches: here: 6, in: 1, it: 1, foooo"
}
