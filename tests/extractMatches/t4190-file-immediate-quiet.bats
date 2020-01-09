#!/usr/bin/env bats

export EXTRACTMATCHES_FILE_UPDATE_DELAY=0
load log

@test "in quiet mode, only matches and counts are written to a file" {
    input="Just some text.
This has foo in it.
All simple lines.
More foooo here.
Seriously."
    run extractMatches --quiet --to "$LOG" --regexp fo+ --count '\<\w{4}\>' --global --match-count '\<i\w\>' --global <<<"$input"
    [ "$output" = "" ]
    assert_log "Just: 1
some: 2
text: 3
This: 4
foo
in: 1
it: 1
More: 5
foooo
here: 6"
}
