#!/usr/bin/env bats

load fixture

@test "invalid format exits with 2 and prints error message" {
    DURATIONTOSECONDS_FORMAT=notAFormat run -2 durationToSeconds 1s
    assert_output 'ERROR: Invalid DURATIONTOSECONDS_FORMAT: notAFormat'
}

@test "force millisecond format on integer durations" {
    typeset -A durations=(
	[2h 30m]=9000.000
	[02:30]=150.000
	[1h 15m 30s]=4530.000
	[01:15:30]=4530.000
	[1d 15m]=87300.000
	[2y 3w 16:42]=64887402.000
    )
    for duration in "${!durations[@]}"
    do
	DURATIONTOSECONDS_FORMAT=ms run -0 durationToSeconds "$duration" \
	    && assert_output "${durations["$duration"]}" \
	    || fail "${duration@Q}"
    done
}

@test "force millisecond format on fractional durations" {
    typeset -A durations=(
	[1ms]=0.001
	[500ms]=0.500
	[1000ms]=1.000
	[1001ms]=1.001
	[00:01.000]=1.000
	[1m 3600000ms]=3660.000
	[1m 3600003ms]=3660.003
    )
    for duration in "${!durations[@]}"
    do
	DURATIONTOSECONDS_ACCEPT_FRACTIONAL=t DURATIONTOSECONDS_FORMAT=ms run -0 durationToSeconds "$duration" \
	    && assert_output "${durations["$duration"]}" \
	    || fail "$duration"
    done
}
