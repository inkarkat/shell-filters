#!/usr/bin/env bats

export EXTRACTMATCHES_NOTIFY_UPDATE_DELAY=-3

load notify

@test "single counts in a line are notify-sent every 3 lines and at the end" {
    run -0 extractMatches --to notify --count 'foo[0-9]+' <<<"$DELAY_INPUT"
    assert_output "$DELAY_INPUT"
    assert_runs "${PREFIX}foo3:2
${PREFIX}foo6:5
${PREFIX}foo8:7"
}

@test "three different counts with different single / global are notify-sent every 3 lines and at the end" {
    run -0 extractMatches --to notify --count 'foo[0-9]+' --global --count 'ex' --count 'y' --global <<<"$DELAY_INPUT"
    assert_output "$DELAY_INPUT"
    assert_runs "${PREFIX}foo3:2, ex:1, y:1
${PREFIX}foo6:5, ex:2, y:1
${PREFIX}foo8:7, ex:2, y:2"
}
