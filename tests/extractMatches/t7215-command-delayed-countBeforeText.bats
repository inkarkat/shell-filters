#!/usr/bin/env bats

export EXTRACTMATCHES_COUNT_BEFORE_TEXT=t
export EXTRACTMATCHES_COUNT_PREFIX=''
export EXTRACTMATCHES_COUNT_SUFFIX=':'
export EXTRACTMATCHES_COMMAND_UPDATE_DELAY=-3

load command

@test "counts in a line are passed to command before the text every 3 lines and at the end" {
    run extractMatches --to command --count 'foo[0-9]+' <<<"$DELAY_INPUT"
    [ "$output" = "$DELAY_INPUT" ]
    assert_runs "2:foo3
5:foo6
7:foo8" ]
}
