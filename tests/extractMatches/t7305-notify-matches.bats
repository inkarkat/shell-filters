#!/usr/bin/env bats

export EXTRACTMATCHES_NOTIFY_UPDATE_DELAY=-3

load notify

@test "single matches in a line are notify-sent every 3 lines and at the end" {
    run -0 extractMatches --to notify --regexp 'foo[0-9]+' <<<"$DELAY_INPUT"
    assert_output "$DELAY_INPUT"
    assert_runs "${PREFIX}foo3
${PREFIX}foo6
${PREFIX}foo8"
}

@test "a match on last line 6 is not notify-sent again" {
    input="Just some text.
This has foo2 in it.
All foo3.
More foo4 here.
That foo5.
Last foo6."
    run -0 extractMatches --to notify --regexp 'foo[0-9]+' <<<"$input"
    assert_output "$input"
    assert_runs "${PREFIX}foo3
${PREFIX}foo6"
}
