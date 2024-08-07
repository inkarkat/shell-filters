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

@test "counts are written every 10 lines with default sorting by argument order" {
    run extractMatches --to "$LOG" --count 'foo[0-9]+' --match-count '\<[[:upper:]]\w{3}\>' --count 'bar[0-9]+' --count 'y' --global <<<"$SORT_INPUT"
    [ "$output" = "$SORT_INPUT" ]
    assert_log "foo9: 8
Gone: 1
Just: 2
Last: 1
More: 1
That: 1
This: 1
Your: 1
bar11: 6
y: 1
This: 3
y: 4"
}

@test "counts are written every 10 lines with explicit sorting by argument order" {
    run extractMatches --to "$LOG" --report-order by-arg --count 'foo[0-9]+' --match-count '\<[[:upper:]]\w{3}\>' --count 'bar[0-9]+' --count 'y' --global <<<"$SORT_INPUT"
    [ "$output" = "$SORT_INPUT" ]
    assert_log "foo9: 8
Gone: 1
Just: 2
Last: 1
More: 1
That: 1
This: 1
Your: 1
bar11: 6
y: 1
This: 3
y: 4"
}

@test "counts are written every 10 lines with count-desc sorting" {
    run extractMatches --to "$LOG" --report-order count-desc --count 'foo[0-9]+' --match-count '\<[[:upper:]]\w{3}\>' --count 'bar[0-9]+' --count 'y' --global <<<"$SORT_INPUT"
    [ "$output" = "$SORT_INPUT" ]
    assert_log "foo9: 8
bar11: 6
Just: 2
Gone: 1
Last: 1
More: 1
That: 1
This: 1
Your: 1
y: 1
y: 4
This: 3"
}

@test "counts are written every 10 lines with recent-match sorting" {
    run extractMatches --to "$LOG" --report-order recent-match --count 'foo[0-9]+' --match-count '\<[[:upper:]]\w{3}\>' --count 'bar[0-9]+' --count 'y' --global <<<"$SORT_INPUT"
    [ "$output" = "$SORT_INPUT" ]
    assert_log "bar11: 6
Just: 2
foo9: 8
Last: 1
Your: 1
Gone: 1
That: 1
More: 1
This: 1
y: 1
y: 4
This: 3"
}

@test "counts are written every 10 lines with first-match sorting" {
    run extractMatches --to "$LOG" --report-order first-match --count 'foo[0-9]+' --match-count '\<[[:upper:]]\w{3}\>' --count 'bar[0-9]+' --count 'y' --global <<<"$SORT_INPUT"
    [ "$output" = "$SORT_INPUT" ]
    assert_log "y: 1
This: 1
More: 1
That: 1
Gone: 1
Your: 1
Last: 1
foo9: 8
Just: 2
bar11: 6
This: 3
y: 4"
}

@test "counts are written every 10 lines with sorting by match" {
    run extractMatches --to "$LOG" --report-order match-asc --count 'foo[0-9]+' --match-count '\<[[:upper:]]\w{3}\>' --count 'bar[0-9]+' --count 'y' --global <<<"$SORT_INPUT"
    [ "$output" = "$SORT_INPUT" ]
    assert_log "Gone: 1
Just: 2
Last: 1
More: 1
That: 1
This: 1
Your: 1
bar11: 6
foo9: 8
y: 1
This: 3
y: 4"
}
