#!/usr/bin/env bats

export EXTRACTMATCHES_NOTIFY_UPDATE_DELAY=-3
load notify

@test "only matches and counts are notify-sent" {
    run extractMatches --summary-only --to notify --regexp fo+ --count '\<\w{4}\>' --global --match-count '\<i\w\>' --global <<<"$DELAY_INPUT"
    [ "$output" = "" ]
    assert_runs "${PREFIX}Last:9, in:1, it:1, foo" ]
}
