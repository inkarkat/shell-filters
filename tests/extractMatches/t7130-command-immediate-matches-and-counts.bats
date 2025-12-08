#!/usr/bin/env bats

export EXTRACTMATCHES_COMMAND_UPDATE_DELAY=0

load command

@test "matches and counts are passed to command" {
    run -0 extractMatches --to command --regexp fo+ --count '\<\w{4}\>' --global --match-count '\<i\w\>' --global <<<"$SIMPLE_INPUT"
    assert_output "$SIMPLE_INPUT"
    assert_runs "text:4
This:5|in:1|it:1|foo
here:7|in:1|it:1|foooo"
}
