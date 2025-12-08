#!/usr/bin/env bats

export EXTRACTMATCHES_COUNT_BEFORE_TEXT=t
export EXTRACTMATCHES_COUNT_PREFIX=''
export EXTRACTMATCHES_COUNT_SUFFIX=':'
export EXTRACTMATCHES_COMMAND_UPDATE_DELAY=0

load command

@test "counts in a line are passed to command before the text" {
    run -0 extractMatches --to command --count fo+ <<<"$SIMPLE_INPUT"
    assert_output "$SIMPLE_INPUT"
    assert_runs "1:foo
2:foooo"
}
