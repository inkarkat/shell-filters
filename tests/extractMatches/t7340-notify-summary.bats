#!/usr/bin/env bats

export EXTRACTMATCHES_NOTIFY_UPDATE_DELAY=-3

load notify

@test "matches and counts are notify-sent at the end" {
    run -0 extractMatches --summary --to notify --regexp fo+ --count '\<\w{4}\>' --global --match-count '\<i\w\>' --global <<<"$DELAY_INPUT"
    assert_output "$DELAY_INPUT"
    assert_runs "${PREFIX}Last:9, in:1, it:1, foo"
}
