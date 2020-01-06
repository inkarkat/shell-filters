#!/usr/bin/env bats

load command

@test "match resets are passed to command" {
    run extractMatches --to command --regexp '\<\w{4}\>' --reset All <<<"$SIMPLE_INPUT"
    [ "$output" = "$SIMPLE_INPUT" ]
    assert_runs "Just
This
More"
}

@test "count resets are passed to command" {
    run extractMatches --to command --count '\<\w{4}\>' --reset All <<<"$SIMPLE_INPUT"
    [ "$output" = "$SIMPLE_INPUT" ]
    assert_runs "Just:1
This:2
More:1"
}

@test "match-count resets are passed to command" {
    run extractMatches --to command --match-count '\<\w{4}\>' --reset All <<<"$SIMPLE_INPUT"
    [ "$output" = "$SIMPLE_INPUT" ]
    assert_runs "Just:1
Just:1|This:1
More:1"
}
