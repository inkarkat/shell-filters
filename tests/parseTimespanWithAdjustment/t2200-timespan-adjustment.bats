#!/usr/bin/env bats

load fixture

@test "passed durations and timespans are converted to seconds and adjustment" {
    typeset -A durations=(
	[1s+1]=$'1\t+1'
	[1s+1s]=$'1\t+1'
	[1s+1m]=$'1\t+60'
	[1s + 1m 11s]=$'1\t+71'
	[1s +01:11]=$'1\t+71'
	[2m 30s - 0m 15s]=$'150\t-15'
	[02:30-01:11]=$'150\t-71'
	[02:30+01:02:03]=$'150\t+3723'
	[2w 3d -1d 2h 3m 4s]=$'1468800\t-93784'
    )

    for duration in "${!durations[@]}"
    do
	run -0 parseTimespanWithAdjustment -- "$duration" \
	    && assert_output "${durations["$duration"]}" \
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
	run -1 parseTimespanWithAdjustment -- "$notAnAdjustment" \
	    && assert_output "ERROR: Illegal ADJUSTMENT-TIMESPAN: ${notAdjustments["$notAnAdjustment"]}" \
	    || fail "${notAnAdjustment@Q}"
    done
}
