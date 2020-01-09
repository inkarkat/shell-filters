#!/usr/bin/env bats

export EXTRACTMATCHES_NOTIFY_UPDATE_DELAY=-3
load notify

@test "in quiet mode, only matches and counts are notify-sent" {
    run extractMatches --quiet --to notify --regexp fo+ --count '\<\w{4}\>' --global --match-count '\<i\w\>' --global <<<"$DELAY_INPUT"
    [ "$output" = "" ]
    assert_runs "${PREFIX}This:4, in:1, it:1, foo
${PREFIX}That:7, in:1, it:1, foo
${PREFIX}Last:9, in:1, it:1, foo" ]
}
