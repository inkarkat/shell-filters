#!/usr/bin/env bats

load command

@test "delayed match is passed to command after delayed counts by default" {
    run extractMatches --to command --regexp fo+ --count '\<\w{4}\>' --global --match-count '\<i\w\>' --global <<<"$SIMPLE_INPUT"
    [ "$output" = "$SIMPLE_INPUT" ]
    assert_runs "text:4
This:5|in:1|it:1|foo
here:7|in:1|it:1|foooo"
}

@test "reconfigured delayed match is passed to command before delayed counts" {
    export EXTRACTMATCHES_MATCH_BEFORE_COUNT=t
    run extractMatches --to command --regexp fo+ --count '\<\w{4}\>' --global --match-count '\<i\w\>' --global <<<"$SIMPLE_INPUT"
    assert_runs "text:4
foo|This:5|in:1|it:1
foooo|here:7|in:1|it:1"
}
