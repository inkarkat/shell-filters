#!/usr/bin/env bats

export EXTRACTMATCHES_FILE_UPDATE_MATCH_DELAY=-3
export EXTRACTMATCHES_FILE_UPDATE_COUNT_DELAY=-3
export EXTRACTMATCHES_COUNT_BEFORE_TEXT=t
export EXTRACTMATCHES_COUNT_PREFIX=''
export EXTRACTMATCHES_COUNT_SUFFIX=':'

load log

@test "counts in a line are written to a file before the text every 3 lines and at the end" {
    run -0 extractMatches --to "$LOG" --count 'foo[0-9]+' <<<"$DELAY_INPUT"
    assert_output "$DELAY_INPUT"
    assert_log "2:foo3
5:foo6
7:foo8"
}
