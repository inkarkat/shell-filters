#!/usr/bin/env bats

export EXTRACTMATCHES_COMMAND_UPDATE_DELAY=-3
load command

@test "in quiet mode, only delayed matches and counts are passed to command" {
    run extractMatches --quiet --to command --regexp fo+ --count '\<\w{4}\>' --global --match-count '\<i\w\>' --global <<<"$DELAY_INPUT"
    [ "$output" = "" ]
    assert_runs "This:4|in:1|it:1|foo
That:7|in:1|it:1|foo
Last:9|in:1|it:1|foo" ]
}
