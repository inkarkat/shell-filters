#!/usr/bin/env bats

export EXTRACTMATCHES_FILE_UPDATE_MATCH_DELAY=-3
export EXTRACTMATCHES_FILE_UPDATE_COUNT_DELAY=-3
load log

@test "only matches and counts are written at the end" {
    run extractMatches --summary-only --to "$LOG" --regexp fo+ --count '\<\w{4}\>' --global --match-count '\<i\w\>' --global <<<"$DELAY_INPUT"
    [ "$output" = "" ]
    assert_log "foo
Last: 9
in: 1
it: 1" ]
}
