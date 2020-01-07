#!/usr/bin/env bats

export EXTRACTMATCHES_FILE_UPDATE_DELAY=-3
load log

@test "single matches in a line are written to a file every 3 lines and at the end" {
    run extractMatches --to "$LOG" --regexp 'foo[0-9]+' <<<"$DELAY_INPUT"
    [ "$output" = "$DELAY_INPUT" ]
    assert_log "foo3
foo6
foo8" ]
}

@test "a match on last line 6 is not written again" {
    input="Just some text.
This has foo2 in it.
All foo3.
More foo4 here.
That foo5.
Last foo6."
    run extractMatches --to "$LOG" --regexp 'foo[0-9]+' <<<"$input"
    [ "$output" = "$input" ]
    assert_log "foo3
foo6" ]
}
