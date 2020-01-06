#!/usr/bin/env bats

load command

@test "match resets by name are passed to command" {

    run extractMatches --to command --reset-name All --name fours --regexp '\<\w{4}\>' --name fours <<<"$SIMPLE_INPUT"
    [ "$output" = "$SIMPLE_INPUT" ]
    assert_runs "Just
This
More"
}

@test "count resets by name are passed to command" {

    run extractMatches --to command --reset-name All --name fours --count '\<\w{4}\>' --name fours <<<"$SIMPLE_INPUT"
    [ "$output" = "$SIMPLE_INPUT" ]
    assert_runs "Just:1
This:2
More:1"
}

@test "match-count resets by name are passed to command" {

    run extractMatches --to command --reset-name All --name fours --match-count '\<\w{4}\>' --name fours <<<"$SIMPLE_INPUT"
    [ "$output" = "$SIMPLE_INPUT" ]
    assert_runs "Just:1
Just:1|This:1
More:1"
}
