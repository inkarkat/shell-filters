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

	[21ms-1ms]='21ms'
	[1s 1ms + 100ms]='1s 1ms'
	[00:01.001+100ms]='00:01.001'
	[1m 3600003ms+3600000ms]='1m 3600003ms'
    )
    for duration in "${!durations[@]}"
    do
	run -1 parseTimespanWithAdjustment "$duration" \
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
	run -1 parseTimespanWithAdjustment "$duration" \
	    && assert_output "ERROR: Illegal ADJUSTMENT-TIMESPAN: ${fractionalAdjustments["$duration"]}" \
	    || fail "${duration@Q}"
    done
}

@test "millisecond durations are converted when fractions are accepted" {
    typeset -A durations=(
	[1ms + 100%]=$'0.001\t+100%'
	[21ms+1s]=$'0.021\t+1'
	[500ms+1]=$'0.500\t+1'
	[1001ms-10%]=$'1.001\t-10%'
	[1s 1ms + 1s]=$'1.001\t+1'
	[00:01.001+1s]=$'1.001\t+1'

	[21s-1ms]=$'21\t-0.001'
	[1m 1s + 100ms]=$'61\t+0.100'
	[00:01+100ms]=$'1\t+0.100'
	[1m+3600000ms]=$'60\t+3600'

	[21ms-1ms]=$'0.021\t-0.001'
	[1s 1ms + 100ms]=$'1.001\t+0.100'
	[00:01.001+100ms]=$'1.001\t+0.100'
	[1m 3600003ms+3600000ms]=$'3660.003\t+3600'
    )

    for duration in "${!durations[@]}"
    do
	PARSETIMESPANWITHADJUSTMENT_ACCEPT_FRACTIONAL=t run -0 parseTimespanWithAdjustment "$duration" \
	    && assert_output "${durations["$duration"]}" \
	    || fail "${duration@Q}"
    done
}
