#!/usr/bin/env bats

load fixture

typeset -grA durations=(
    [1ms]=0.001
    [21ms]=0.021
    [500ms]=0.500
    [1001ms]=1.001
    [1s 1ms]=1.001
    [00:01.001]=1.001
    [1m 99ms]=60.099
    [01:00.099]=60.099
    [60099ms]=60.099
    [1h 2s 3ms]=3602.003
    [1h 2003ms]=3602.003
    [01:00:02.003]=3602.003
    [1m 3600003ms]=3660.003
)

@test "millisecond durations are rejected by default" {
    for duration in "${!durations[@]}"
    do
	run -1 durationToSeconds "$duration" \
	    && assert_output '' \
	    || fail "$duration"
    done
}

@test "millisecond durations are converted when fractions are accepted" {
    for duration in "${!durations[@]}"
    do
	DURATIONTOSECONDS_ACCEPT_FRACTIONAL=t run -0 durationToSeconds "$duration" \
	    && assert_output "${durations["$duration"]}" \
	    || fail "$duration"
    done
}
