#!/usr/bin/env bats

export EXTRACTMATCHES_COMMAND_UPDATE_DELAY=-3

load command

@test "only matches and counts are passed to command" {
    run -0 extractMatches --summary-only --to command --regexp fo+ --count '\<\w{4}\>' --global --match-count '\<i\w\>' --global <<<"$DELAY_INPUT"
    assert_output ''
    assert_runs "Last:9|in:1|it:1|foo"
}
