#!/usr/bin/env bats

export EXTRACTMATCHES_FILE_UPDATE_DELAY=-3
load log

@test "matches and counts are written at the end" {
    run extractMatches --summary-only --to "$LOG" --regexp fo+ --count '\<\w{4}\>' --global --match-count '\<i\w\>' --global <<<"$DELAY_INPUT"
    [ "$output" = "$DELAY_INPUT" ]
    assert_log "foo
Last: 9
in: 1
it: 1" ]
}
