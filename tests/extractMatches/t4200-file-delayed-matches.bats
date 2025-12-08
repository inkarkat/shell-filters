#!/usr/bin/env bats

export EXTRACTMATCHES_FILE_UPDATE_MATCH_DELAY=-3
export EXTRACTMATCHES_FILE_UPDATE_COUNT_DELAY=-3

load log

@test "single matches in a line are written to a file every 3 lines and at the end" {
    run -0 extractMatches --to "$LOG" --regexp 'foo[0-9]+' <<<"$DELAY_INPUT"
    assert_output "$DELAY_INPUT"
    assert_log "foo3
foo6
foo8"
}

@test "a match on last line 6 is not written again" {
    input="Just some text.
This has foo2 in it.
All foo3.
More foo4 here.
That foo5.
Last foo6."
    run -0 extractMatches --to "$LOG" --regexp 'foo[0-9]+' <<<"$input"
    assert_output "$input"
    assert_log "foo3
foo6"
}
