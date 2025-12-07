#!/usr/bin/env bats

export EXTRACTMATCHES_COMMAND_UPDATE_DELAY=0

load command

@test "single matches in a line are passed to command" {
    run -0 extractMatches --to command --regexp fo+ <<<"$SIMPLE_INPUT"
    assert_output "$SIMPLE_INPUT"
    assert_runs "foo
foooo"
}

@test "three different matches with different single / global are passed to command" {
    run -0 extractMatches --to command --regexp fo+ --global --regexp 'ex' --regexp 'y' --global <<<"$SIMPLE_INPUT"
    assert_output "$SIMPLE_INPUT"
    assert_runs "y
foo
foooo
y"
}
