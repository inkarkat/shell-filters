#!/usr/bin/env bats

load fixture

@test "millisecond durations are rejected by default" {
    typeset -A durations=(
	[1ms + 100%]='1ms'
	[21ms+1s]='21ms'
	[500ms+1]='500ms'
	[1001ms-10%]='1001ms'
	[1s 1ms + 1s]='1s 1ms'
	[00:01.001+1s]='00:01.001'
	[20ms + 0.1]='20ms'
	[1.10 + 0.05]='1.10'

	[21ms-1ms]='21ms'
	[1s 1ms + 100ms]='1s 1ms'
	[00:01.001+100ms]='00:01.001'
	[1m 3600003ms+3600000ms]='1m 3600003ms'
    )
    for duration in "${!durations[@]}"
    do
	run -1 durationWithAdjustmentToSeconds "$duration" \
	    && assert_output "ERROR: Illegal TIMESPAN: ${durations["$duration"]}" \
	    || fail "${duration@Q}"
    done

    typeset -A fractionalAdjustments=(
	[21s-1ms]='-1ms'
	[1m 1s + 100ms]='+100ms'
	[00:01+100ms]='+100ms'
	[1m+3600000ms]='+3600000ms'
    )

    for duration in "${!fractionalAdjustments[@]}"
    do
	run -1 durationWithAdjustmentToSeconds "$duration" \
	    && assert_output "ERROR: Illegal ADJUSTMENT-TIMESPAN: ${fractionalAdjustments["$duration"]}" \
	    || fail "${duration@Q}"
    done
}

@test "millisecond durations are converted when fractions are accepted" {
    typeset -A durations=(
	[1ms + 100%]=0.002
	[21ms+1s]=1.021
	[500ms+1]=1.5
	[1001ms-10%]=0.9009
	[1s 1ms + 1s]=2.001
	[00:01.001+1s]=2.001
	[20ms + 0.1]=0.12
	[1.10 + 0.05]=1.15

	[21s-1ms]=20.999
	[1m 1s + 100ms]=61.1
	[00:01+100ms]=1.1
	[1m+3600000ms]=3660

	[21ms-1ms]=0.02
	[1s 1ms + 100ms]=1.101
	[00:01.001+100ms]=1.101
	[1m 3600003ms+3600000ms]=7260.003
    )

    for duration in "${!durations[@]}"
    do
	DURATIONWITHADJUSTMENTTOSECONDS_ACCEPT_FRACTIONAL=t run -0 durationWithAdjustmentToSeconds "$duration" \
	    && assert_output "${durations["$duration"]}" \
	    || fail "${duration@Q}"
    done
}
