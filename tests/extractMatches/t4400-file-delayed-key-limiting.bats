#!/usr/bin/env bats

readonly SORT_INPUT="Just sexy text.
This has foo2 and bar9 in it.
All foo3 and bar3.
More foo4 here.
That bar1 and foo5.
Rex' foo6.
Gone are bar5 and foo7.
Your bar7 and foo8.
Last foo9.
Just bar11.
This almost concludes it; barB.
This really mostly ends soon; barA.
Seriously; barC."

export EXTRACTMATCHES_FILE_UPDATE_MATCH_DELAY=-10
export EXTRACTMATCHES_FILE_UPDATE_COUNT_DELAY=-10
load log

@test "counts are written every 10 lines with default sorting by argument order limited to 3" {
    run extractMatches --to "$LOG" --report-limit 3 --count 'foo[0-9]+' --match-count '\<[[:upper:]]\w{3}\>' --count 'bar[0-9]+' --count 'y' --global <<<"$SORT_INPUT"
    [ "$output" = "$SORT_INPUT" ]
    assert_log "foo9: 8
Gone: 1
Just: 2
This: 3
y: 4"
}

@test "counts are written every 10 lines with count-desc sorting limited to 1" {
    run extractMatches --to "$LOG" --report-order count-desc --report-limit 1 --count 'foo[0-9]+' --match-count '\<[[:upper:]]\w{3}\>' --count 'bar[0-9]+' --count 'y' --global <<<"$SORT_INPUT"
    [ "$output" = "$SORT_INPUT" ]
    assert_log "foo9: 8
y: 4"
}

@test "counts are written every 10 lines with recent-match sorting limited to 1" {
    run extractMatches --to "$LOG" --report-order recent-match --report-limit 1 --count 'foo[0-9]+' --match-count '\<[[:upper:]]\w{3}\>' --count 'bar[0-9]+' --count 'y' --global <<<"$SORT_INPUT"
    [ "$output" = "$SORT_INPUT" ]
    assert_log "bar11: 6
y: 4"
}

@test "counts are written every 10 lines with first-match sorting limited to 1" {
    run extractMatches --to "$LOG" --report-order first-match --report-limit 1 --count 'foo[0-9]+' --match-count '\<[[:upper:]]\w{3}\>' --count 'bar[0-9]+' --count 'y' --global <<<"$SORT_INPUT"
    [ "$output" = "$SORT_INPUT" ]
    assert_log "y: 1
This: 3"
}
