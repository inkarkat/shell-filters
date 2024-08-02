#!/usr/bin/env bats

export EXTRACTMATCHES_NOTIFY_UPDATE_DELAY=-3
load notify

@test "delayed match is notify-sent after delayed counts by default" {
    run extractMatches --to notify --regexp fo+ --count '\<\w{4}\>' --global --match-count '\<i\w\>' --global <<<"$DELAY_INPUT"
    [ "$output" = "$DELAY_INPUT" ]
    assert_runs "${PREFIX}This:4, in:1, it:1, foo
${PREFIX}That:7, in:1, it:1, foo
${PREFIX}Last:9, in:1, it:1, foo" ]
}

@test "reconfigured delayed match is notify-sent before delayed counts" {
    export EXTRACTMATCHES_MATCH_BEFORE_COUNTS=t
    run extractMatches --to notify --regexp fo+ --count '\<\w{4}\>' --global --match-count '\<i\w\>' --global <<<"$DELAY_INPUT"
    [ "$output" = "$DELAY_INPUT" ]
    assert_runs "${PREFIX}foo, This:4, in:1, it:1
${PREFIX}foo, That:7, in:1, it:1
${PREFIX}foo, Last:9, in:1, it:1" ]
}
