#!/usr/bin/env bats

export EXTRACTMATCHES_COMMAND_UPDATE_DELAY=0

load command

@test "delayed match is passed to command after delayed counts by default" {
    run -0 extractMatches --to command --regexp fo+ --count '\<\w{4}\>' --global --match-count '\<i\w\>' --global <<<"$SIMPLE_INPUT"
    assert_output "$SIMPLE_INPUT"
    assert_runs "text:4
This:5|in:1|it:1|foo
here:7|in:1|it:1|foooo"
}

@test "reconfigured delayed match is passed to command before delayed counts" {
    export EXTRACTMATCHES_MATCH_BEFORE_COUNTS=t
    run -0 extractMatches --to command --regexp fo+ --count '\<\w{4}\>' --global --match-count '\<i\w\>' --global <<<"$SIMPLE_INPUT"
    assert_runs "text:4
foo|This:5|in:1|it:1
foooo|here:7|in:1|it:1"
}
