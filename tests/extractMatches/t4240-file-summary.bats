#!/usr/bin/env bats

export EXTRACTMATCHES_FILE_UPDATE_MATCH_DELAY=-3
export EXTRACTMATCHES_FILE_UPDATE_COUNT_DELAY=-3

load log

@test "matches and counts are written at the end" {
    run -0 extractMatches --summary --to "$LOG" --regexp fo+ --count '\<\w{4}\>' --global --match-count '\<i\w\>' --global <<<"$DELAY_INPUT"
    assert_output "$DELAY_INPUT"
    assert_log "foo
Last: 9
in: 1
it: 1"
}
