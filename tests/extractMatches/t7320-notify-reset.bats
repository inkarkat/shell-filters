#!/usr/bin/env bats

export EXTRACTMATCHES_NOTIFY_UPDATE_DELAY=-3
load notify

@test "match resets are notify-sent every 3 lines and at the end" {
    run extractMatches --to notify --regexp 'foo[0-9]+' --reset 'All|Your' <<<"$DELAY_INPUT"
    [ "$output" = "$DELAY_INPUT" ]
    assert_runs "${PREFIX}foo3
${PREFIX}foo6
${PREFIX}foo8" ]
}

@test "count resets are notify-sent every 3 lines and at the end" {
    run extractMatches --to notify --count 'foo[24-9]+' --reset 'All|Your' <<<"$DELAY_INPUT"
    [ "$output" = "$DELAY_INPUT" ]
    assert_runs "${PREFIX}foo6:3
${PREFIX}foo8:2" ]
}

@test "match-count resets are notify-sent every 3 lines and at the end" {
    run extractMatches --to notify --match-count '\<\w{4}\>' --reset 'All|Rex' <<<"$DELAY_INPUT"
    [ "$output" = "$DELAY_INPUT" ]
    assert_runs "${PREFIX}foo3:1
${PREFIX}foo6:1
${PREFIX}Last:1|Your:1|foo6:1" ]
}
