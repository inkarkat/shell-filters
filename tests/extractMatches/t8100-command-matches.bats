#!/usr/bin/env bats

load command

@test "single matches in a line are passed to command" {
    run extractMatches --to command --regexp fo+ <<<"$SIMPLE_INPUT"
    [ "$output" = "$SIMPLE_INPUT" ]
    assert_runs "foo
foooo"
}

@test "three different matches with different single / global are passed to command" {
    run extractMatches --to command --regexp fo+ --global --regexp 'ex' --regexp 'y' --global <<<"$SIMPLE_INPUT"
    [ "$output" = "$SIMPLE_INPUT" ]
    assert_runs "y
foo
foooo
y"
}
