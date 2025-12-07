#!/usr/bin/env bats

export EXTRACTMATCHES_COMMAND_UPDATE_DELAY=-3

load command

@test "matches and counts are passed to command at the end" {
    run -0 extractMatches --summary --to command --regexp fo+ --count '\<\w{4}\>' --global --match-count '\<i\w\>' --global <<<"$DELAY_INPUT"
    assert_output "$DELAY_INPUT"
    assert_runs "Last:9|in:1|it:1|foo"
}
