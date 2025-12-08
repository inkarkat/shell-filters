#!/usr/bin/env bats

export EXTRACTMATCHES_COMMAND_UPDATE_DELAY=-3

load command

@test "single counts in a line are passed to command every 3 lines and at the end" {
    run -0 extractMatches --to command --count 'foo[0-9]+' <<<"$DELAY_INPUT"
    assert_output "$DELAY_INPUT"
    assert_runs "foo3:2
foo6:5
foo8:7"
}

@test "three different counts with different single / global are passed to command every 3 lines and at the end" {
    run -0 extractMatches --to command --count 'foo[0-9]+' --global --count 'ex' --count 'y' --global <<<"$DELAY_INPUT"
    assert_output "$DELAY_INPUT"
    assert_runs "foo3:2|ex:1|y:1
foo6:5|ex:2|y:1
foo8:7|ex:2|y:2"
}
