#!/usr/bin/env bats

export EXTRACTMATCHES_COMMAND_UPDATE_DELAY=0

load command

@test "match resets are passed to command" {
    run -0 extractMatches --to command --regexp '\<\w{4}\>' --reset All <<<"$SIMPLE_INPUT"
    assert_output "$SIMPLE_INPUT"
    assert_runs "Just
This
More"
}

@test "count resets are passed to command" {
    run -0 extractMatches --to command --count '\<\w{4}\>' --reset All <<<"$SIMPLE_INPUT"
    assert_output "$SIMPLE_INPUT"
    assert_runs "Just:1
This:2
More:1"
}

@test "match-count resets are passed to command" {
    run -0 extractMatches --to command --match-count '\<\w{4}\>' --reset All <<<"$SIMPLE_INPUT"
    assert_output "$SIMPLE_INPUT"
    assert_runs "Just:1
Just:1|This:1
More:1"
}
