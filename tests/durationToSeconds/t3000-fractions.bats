#!/usr/bin/env bats

load fixture

typeset -grA durations=(
    [1.0]=1
    [1.00000]=1
    [1.1]=1.1
    [1.03]=1.03
    [1.00000001]=1.00000001
    [1.123456]=1.123456
    [1.111999]=1.111999
    [1ms]=0.001
    [21ms]=0.021
    [500ms]=0.5
    [560ms]=0.56
    [567ms]=0.567
    [1000ms]=1
    [1001ms]=1.001
    [1s 0ms]=1
    [1s 1ms]=1.001
    [00:01.001]=1.001
    [00:01.01]=1.01
    [00:01.1]=1.1
    [1m 99ms]=60.099
    [01:00.099]=60.099
    [01:00.0999]=60.0999
    [01:00.099998]=60.099998
    [01:00.099990]=60.09999
    [60099ms]=60.099
    [1h 2s 3ms]=3602.003
    [1h 2003ms]=3602.003
    [01:00:02.003]=3602.003
    [1m 3600000ms]=3660
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
