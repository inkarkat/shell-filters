#!/usr/bin/env bats

export EXTRACTMATCHES_COMMAND_UPDATE_DELAY=-3

load command

@test "match resets are passed to command every 3 lines and at the end" {
    run -0 extractMatches --to command --regexp 'foo[0-9]+' --reset 'All|Your' <<<"$DELAY_INPUT"
    assert_output "$DELAY_INPUT"
    assert_runs "foo3
foo6
foo8"
}

@test "count resets are passed to command every 3 lines and at the end" {
    run -0 extractMatches --to command --count 'foo[24-9]+' --reset 'All|Your' <<<"$DELAY_INPUT"
    assert_output "$DELAY_INPUT"
    assert_runs "foo6:3
foo8:2"
}

@test "match-count resets are passed to command every 3 lines and at the end" {
    run -0 extractMatches --to command --match-count '\<\w{4}\>' --reset 'All|Rex' <<<"$DELAY_INPUT"
    assert_output "$DELAY_INPUT"
    assert_runs "foo3:1
foo6:1
Last:1|Your:1|foo6:1"
}
