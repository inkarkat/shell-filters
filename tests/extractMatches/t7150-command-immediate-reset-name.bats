#!/usr/bin/env bats

export EXTRACTMATCHES_COMMAND_UPDATE_DELAY=0

load command

@test "match resets by name are passed to command" {

    run -0 extractMatches --to command --reset-name All --name fours --regexp '\<\w{4}\>' --name fours <<<"$SIMPLE_INPUT"
    assert_output "$SIMPLE_INPUT"
    assert_runs "Just
This
More"
}

@test "count resets by name are passed to command" {

    run -0 extractMatches --to command --reset-name All --name fours --count '\<\w{4}\>' --name fours <<<"$SIMPLE_INPUT"
    assert_output "$SIMPLE_INPUT"
    assert_runs "Just:1
This:2
More:1"
}

@test "match-count resets by name are passed to command" {

    run -0 extractMatches --to command --reset-name All --name fours --match-count '\<\w{4}\>' --name fours <<<"$SIMPLE_INPUT"
    assert_output "$SIMPLE_INPUT"
    assert_runs "Just:1
Just:1|This:1
More:1"
}
