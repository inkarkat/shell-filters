#!/usr/bin/env bats

export EXTRACTMATCHES_FILE_UPDATE_MATCH_DELAY=-3
export EXTRACTMATCHES_FILE_UPDATE_COUNT_DELAY=-3
load log

@test "delayed match is written before delayed counts by default" {
    run extractMatches --to "$LOG" --regexp fo+ --count '\<\w{4}\>' --global --match-count '\<i\w\>' --global <<<"$DELAY_INPUT"
    [ "$output" = "$DELAY_INPUT" ]
    assert_log "foo
This: 4
in: 1
it: 1
foo
That: 7
foo
Last: 9" ]
}

@test "reconfigured delayed match is written after delayed counts" {
    export EXTRACTMATCHES_MATCH_BEFORE_COUNT=''
    run extractMatches --to "$LOG" --regexp fo+ --count '\<\w{4}\>' --global --match-count '\<i\w\>' --global <<<"$DELAY_INPUT"
    [ "$output" = "$DELAY_INPUT" ]
    assert_log "This: 4
in: 1
it: 1
foo
That: 7
foo
Last: 9
foo" ]
}
