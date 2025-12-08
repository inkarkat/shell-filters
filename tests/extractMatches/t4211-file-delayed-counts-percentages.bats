#!/usr/bin/env bats

export EXTRACTMATCHES_FILE_UPDATE_MATCH_DELAY=-3
export EXTRACTMATCHES_FILE_UPDATE_COUNT_DELAY=-3

load log

@test "three different counts with different single / global are written with percentages to a file every 3 lines and at the end" {
    run -0 extractMatches --name-percentages '/^foo|^ex/' --name-percentages single --to "$LOG" --count 'foo[0-9]+' --global --count 'ex' --global --count 'y' --global --name single --count 'l' --global --name single <<<"$DELAY_INPUT"
    assert_output "$DELAY_INPUT"
    assert_log "foo3: 2 = 50%
ex: 2 = 50%
y: 1 = 33%
l: 2 = 67%
foo6: 5 = 62%
ex: 3 = 38%
foo8: 7 = 70%
y: 2 = 40%
l: 3 = 60%"
}
