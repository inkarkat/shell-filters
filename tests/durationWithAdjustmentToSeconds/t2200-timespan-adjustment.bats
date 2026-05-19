#!/usr/bin/env bats

load fixture

@test "passed durations and timespans are converted to adjusted seconds" {
    typeset -A durations=(
	[1s+1]=2
	[1s+1s]=2
	[1s+1m]=61
	[1s + 1m 11s]=72
	[1s +01:11]=72
	[2m 30s - 0m 15s]=135
	[02:30-01:11]=79
	[02:30+01:02:03]=3873
	[2w 3d -1d 2h 3m 4s]=1375016
    )

    for duration in "${!durations[@]}"
    do
	run -0 durationWithAdjustmentToSeconds -- "$duration" \
	    && assert_output "${durations["$duration"]}" \
	    || fail "${duration@Q}"
    done
}

@test "negative adjusted timespans do not go below zero" {
    typeset -a belowZeroDurations=(
	'1s-1'
	'1s-2s'
	'1h-1h'
	'1h-2h'
	'1h-60m'
	'1h-99m'
	'1h-3600'
	'1h-9999'
	'77 - 1h 17m'
	'2m 30s - 02:30'
	'2m 30s - 02:31'
    )

    for duration in "${belowZeroDurations[@]}"
    do
	run -0 durationWithAdjustmentToSeconds -- "$duration" \
	    && assert_output '0' \
	    || fail "$duration"
    done
}

@test "invalid adjustments exit 1 and print error message" {
    typeset -A notAdjustments=(
	[1s+notAnAdjustment]='+notAnAdjustment'
	[1s +not a duration]='+not a duration'
	[1s+1x]='+1x'
	[1h + what]='+what'
	[1h -42x]='-42x'
	[1h + 15x]='+15x'
	[1h + 10s 1m]='+10s 1m'
	[1h+01:15:30:55]='+01:15:30:55'
	[1d + 1d 15m 2h]='+1d 15m 2h'
	[1w-1s 15m 2h]='-1s 15m 2h'
    )

    for notAnAdjustment in "${!notAdjustments[@]}"
    do
	run -1 durationWithAdjustmentToSeconds -- "$notAnAdjustment" \
	    && assert_output "ERROR: Illegal ADJUSTMENT-TIMESPAN: ${notAdjustments["$notAnAdjustment"]}" \
	    || fail "${notAnAdjustment@Q}"
    done
}
