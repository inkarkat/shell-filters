#!/usr/bin/env bats

export EXTRACTMATCHES_FILE_UPDATE_MATCH_DELAY=0
export EXTRACTMATCHES_FILE_UPDATE_COUNT_DELAY=0
load log

@test "match resets are written to a file" {
    run extractMatches --to "$LOG" --regexp '\<\w{4}\>' --reset All <<<"$SIMPLE_INPUT"
    [ "$output" = "$SIMPLE_INPUT" ]
    assert_log "Just
This
Off: This
More"
}

@test "match resets are not written to a file if the template is empty" {
    export EXTRACTMATCHES_FILE_CLEAR_MATCH_TEMPLATE=
    run extractMatches --to "$LOG" --regexp '\<\w{4}\>' --reset All <<<"$SIMPLE_INPUT"
    [ "$output" = "$SIMPLE_INPUT" ]
    assert_log "Just
This
More"
}

@test "count resets are written to a file" {
    run extractMatches --to "$LOG" --count '\<\w{4}\>' --reset All <<<"$SIMPLE_INPUT"
    [ "$output" = "$SIMPLE_INPUT" ]
    assert_log "Just: 1
This: 2
This: 0
More: 1"
}

@test "match-count resets are written to a file" {
    run extractMatches --to "$LOG" --match-count '\<\w{4}\>' --reset All <<<"$SIMPLE_INPUT"
    [ "$output" = "$SIMPLE_INPUT" ]
    assert_log "Just: 1
This: 1
Just: 0
This: 0
More: 1"
}
