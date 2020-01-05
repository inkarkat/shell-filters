#!/usr/bin/env bats

export EXTRACTMATCHES_FILE_UPDATE_DELAY=-3
load log

@test "match resets are written to a file every 3 lines and at the end" {
    run extractMatches --to "$LOG" --regexp 'foo[0-9]+' --reset 'All|Your' <<<"$DELAY_INPUT"
    [ "$output" = "$DELAY_INPUT" ]
    assert_log "Off: foo2
foo3
foo6
Off: foo6
foo8" ]
}


@test "match resets are not written to a file every 3 lines and at the end if the template is empty" {
    export EXTRACTMATCHES_FILE_CLEAR_MATCH_TEMPLATE=
    run extractMatches --to "$LOG" --regexp 'foo[0-9]+' --reset 'All|Your' <<<"$DELAY_INPUT"
    [ "$output" = "$DELAY_INPUT" ]
    assert_log "foo3
foo6
foo8" ]
}

@test "count resets are written to a file every 3 lines and at the end" {
    run extractMatches --to "$LOG" --count 'foo[24-9]+' --reset 'All|Your' <<<"$DELAY_INPUT"
    [ "$output" = "$DELAY_INPUT" ]
    assert_log "foo2: 0
foo6: 3
foo8: 2" ]
}


@test "match-count resets are not written to a file every 3 lines and at the end if the template is empty" {
    export EXTRACTMATCHES_FILE_CLEAR_MATCH_TEMPLATE=
    run extractMatches --to "$LOG" --match-count '\<\w{4}\>' --reset 'All|Rex' <<<"$DELAY_INPUT"
    [ "$output" = "$DELAY_INPUT" ]
    assert_log "foo3: 1
Just: 0
This: 0
foo6: 1
More: 0
That: 0
foo3: 0
Last: 1
Your: 1" ]
}

