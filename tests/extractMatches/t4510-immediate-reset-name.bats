#!/usr/bin/env bats

export EXTRACTMATCHES_FILE_UPDATE_DELAY=0
load log

@test "match resets by name are written to a file" {

    run extractMatches --to "$LOG" --reset-name All --name fours --regexp '\<\w{4}\>' --name fours <<<"$SIMPLE_INPUT"
    [ "$output" = "$SIMPLE_INPUT" ]
    assert_log "Just
This
Off: This
More"
}

@test "count resets by name are written to a file" {

    run extractMatches --to "$LOG" --reset-name All --name fours --count '\<\w{4}\>' --name fours <<<"$SIMPLE_INPUT"
    [ "$output" = "$SIMPLE_INPUT" ]
    assert_log "Just: 1
This: 2
This: 0
More: 1"
}

@test "match-count resets by name are written to a file" {

    run extractMatches --to "$LOG" --reset-name All --name fours --match-count '\<\w{4}\>' --name fours <<<"$SIMPLE_INPUT"
    [ "$output" = "$SIMPLE_INPUT" ]
    assert_log "Just: 1
This: 1
This: 0
Just: 0
More: 1"
}
