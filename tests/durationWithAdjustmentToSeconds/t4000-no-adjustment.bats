#!/usr/bin/env bats

load fixture

@test "passed durations are converted to seconds with --no-adjustment" {
    typeset -A durations=(
	[1s]=1
	[1m]=60
	[2h 30m]=9000
	[02:30]=150
	[1d 15m]=87300
    )

    for duration in "${!durations[@]}"
    do
	run -0 durationWithAdjustmentToSeconds --no-adjustment -- "$duration" \
	    && assert_output "${durations["$duration"]}" \
	    || fail "${duration@Q}"
    done
}

@test "durations and percentages are output separately with --no-adjustment" {
    typeset -A durations=(
	[1s+1%]=$'1\t+1%'
	[1s+100%]=$'1\t+100%'
	[1s+1000%]=$'1\t+1000%'
	[2m 30s + 9%]=$'150\t+9%'
	[02:30+9%]=$'150\t+9%'
	[02:30 +9%]=$'150\t+9%'
	[02:30 - 9%]=$'150\t-9%'
	[02:30-9%]=$'150\t-9%'
    )

    for duration in "${!durations[@]}"
    do
	run -0 durationWithAdjustmentToSeconds --no-adjustment -- "$duration" \
	    && assert_output "${durations["$duration"]}" \
	    || fail "${duration@Q}"
    done
}

@test "durations and timespans are output separately with --no-adjustment" {
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
	run -0 durationWithAdjustmentToSeconds --no-adjustment -- "$duration" \
	    && assert_output "${durations["$duration"]}" \
	    || fail "${duration@Q}"
    done
}
