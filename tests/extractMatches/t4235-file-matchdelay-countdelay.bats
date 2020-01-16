#!/usr/bin/env bats

load log

@test "delayed matches are written more often than delayed counts" {
    export EXTRACTMATCHES_FILE_UPDATE_MATCH_DELAY=-3
    export EXTRACTMATCHES_FILE_UPDATE_COUNT_DELAY=-5
    run extractMatches --to "$LOG" --regexp fo+ --count '\<\w{4}\>' --global --match-count '\<i\w\>' --global <<<"$DELAY_INPUT"
    [ "$output" = "$DELAY_INPUT" ]
    assert_log "foo
That: 7
in: 1
it: 1
foo
foo
Last: 9" ]
}

@test "delayed matches are written less often than delayed counts" {
    export EXTRACTMATCHES_FILE_UPDATE_MATCH_DELAY=-5
    export EXTRACTMATCHES_FILE_UPDATE_COUNT_DELAY=-3
    run extractMatches --to "$LOG" --regexp fo+ --count '\<\w{4}\>' --global --match-count '\<i\w\>' --global <<<"$DELAY_INPUT"
    [ "$output" = "$DELAY_INPUT" ]
    assert_log "This: 4
in: 1
it: 1
foo
That: 7
Last: 9
foo" ]
}
