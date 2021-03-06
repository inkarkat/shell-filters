#!/usr/bin/env bats

export EXTRACTMATCHES_FILE_UPDATE_MATCH_DELAY=-3
export EXTRACTMATCHES_FILE_UPDATE_COUNT_DELAY=-3
load log

@test "single counts in a line are written to a file every 3 lines and at the end" {
    run extractMatches --to "$LOG" --count 'foo[0-9]+' <<<"$DELAY_INPUT"
    [ "$output" = "$DELAY_INPUT" ]
    assert_log "foo3: 2
foo6: 5
foo8: 7" ]
}

@test "three different counts with different single / global are written to a file every 3 lines and at the end" {
    run extractMatches --to "$LOG" --count 'foo[0-9]+' --global --count 'ex' --count 'y' --global <<<"$DELAY_INPUT"
    [ "$output" = "$DELAY_INPUT" ]
    assert_log "foo3: 2
ex: 1
y: 1
foo6: 5
ex: 2
foo8: 7
y: 2"
}
