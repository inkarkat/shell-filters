#!/usr/bin/env bats

load log

@test "matches and counts are written as concatenated lines to separate file" {
    input="Just some text.
This has foo in it.
All simple lines.
More foooo here.
Seriously."
    export EXTRACTMATCHES_CONCATENATED_FILE="$LOG"
    run -0 extractMatches --to concatenated --regexp fo+ --count '\<\w{4}\>' --global --match-count '\<i\w\>' --global <<<"$input"
    assert_output "$input"
    assert_log "extracted matches: text: 3
extracted matches: This: 4, in: 1, it: 1, foo
extracted matches: here: 6, in: 1, it: 1, foooo" ]
}
