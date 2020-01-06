#!/usr/bin/env bats

export EXTRACTMATCHES_COMMAND_UPDATE_DELAY=-3
load command

@test "delayed match is passed to command after delayed counts by default" {
    run extractMatches --to command --regexp fo+ --count '\<\w{4}\>' --global --match-count '\<i\w\>' --global <<<"$DELAY_INPUT"
    [ "$output" = "$DELAY_INPUT" ]
    assert_runs "This:4|in:1|it:1|foo
That:7|in:1|it:1|foo
Last:9|in:1|it:1|foo" ]
}

@test "reconfigured delayed match is passed to command before delayed counts" {
    export EXTRACTMATCHES_MATCH_BEFORE_COUNT=t
    run extractMatches --to command --regexp fo+ --count '\<\w{4}\>' --global --match-count '\<i\w\>' --global <<<"$DELAY_INPUT"
    [ "$output" = "$DELAY_INPUT" ]
    assert_runs "foo|This:4|in:1|it:1
foo|That:7|in:1|it:1
foo|Last:9|in:1|it:1" ]
}
