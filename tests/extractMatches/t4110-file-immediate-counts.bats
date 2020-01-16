#!/usr/bin/env bats

export EXTRACTMATCHES_FILE_UPDATE_MATCH_DELAY=0
export EXTRACTMATCHES_FILE_UPDATE_COUNT_DELAY=0
load log

@test "single counts in a line are written to a file" {
    input="Just some text.
This has foo in it.
All simple lines.
More foo here.
Seriously."
    run extractMatches --to "$LOG" --count fo+ <<<"$input"
    [ "$output" = "$input" ]
    assert_log "foo: 1
foo: 2"
}

@test "three different counts with different single / global are written to a file" {
    input="Just some sexy text.
This has foo, foo and foofoo in it.
All simple lines.
More foo here.
Seriously, why?"
    run extractMatches --to "$LOG" --count fo+ --global --count 'ex' --count 'y' --global <<<"$input"
    [ "$output" = "$input" ]
    assert_log "ex: 1
y: 1
foo: 1
foo: 2
foo: 3
foo: 4
foo: 5
y: 2
y: 3"
}
