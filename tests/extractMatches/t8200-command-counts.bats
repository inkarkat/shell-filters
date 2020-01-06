#!/usr/bin/env bats

load command

@test "single counts in a line are passed to command" {
    run extractMatches --to command --count fo+ <<<"$SIMPLE_INPUT"
    [ "$output" = "$SIMPLE_INPUT" ]
    assert_runs "foo:1
foooo:2"
}

@test "three different counts with different single / global are passed to command" {
    run extractMatches --to command --count fo+ --global --count 'ex' --count 'y' --global <<<"$SIMPLE_INPUT"
    [ "$output" = "$SIMPLE_INPUT" ]
    assert_runs "ex:1|y:1
foo:1|ex:1|y:1
foooo:2|ex:1|y:1
foooo:2|ex:1|y:2"
}
