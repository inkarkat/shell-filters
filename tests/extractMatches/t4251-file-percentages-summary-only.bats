#!/usr/bin/env bats

export EXTRACTMATCHES_FILE_UPDATE_MATCH_DELAY=-3
export EXTRACTMATCHES_FILE_UPDATE_COUNT_DELAY=-3
load log

@test "only combined matches and counts with percentages are written at the end" {
    run extractMatches --summary-only --to "$LOG" --regexp fo+ --count '\<\w{4}\>' --global --match-count '\<i\w\>' --global --name all --name-percentages all <<<"$DELAY_INPUT"
    [ "$output" = "" ]
    assert_log "foo
Last: 9
in: 1 = 50%
it: 1 = 50%" ]
}

@test "three different counts with different single / global are written with percentages at the end" {
    run extractMatches --summary-only --name-percentages '/^foo|^ex/' --name-percentages single --to "$LOG" --count 'foo[0-9]+' --global --count 'ex' --global --count 'y' --global --name single --count 'l' --global --name single <<<"$DELAY_INPUT"
    [ "$output" = "" ]
    assert_log "foo8: 7 = 70%
ex: 3 = 30%
y: 2 = 40%
l: 3 = 60%"
}
