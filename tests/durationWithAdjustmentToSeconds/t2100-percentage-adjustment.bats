#!/usr/bin/env bats

load fixture

@test "passed durations and percentages are converted to adjusted seconds" {
    typeset -A durations=(
	[1s+1%]=1
	[1s+100%]=2
	[1s+1000%]=11
	[2m 30s + 9%]=164
	[02:30+9%]=164
	[02:30 +9%]=164
	[02:30 - 9%]=137
	[02:30-9%]=137
    )

    for duration in "${!durations[@]}"
    do
	run -0 durationWithAdjustmentToSeconds -- "$duration" \
	    && assert_output "${durations["$duration"]}" \
	    || fail "$duration"
    done
}

@test "negative percentages do not go below zero" {
    typeset -a belowZeroDurations=(
	'1h-100%'
	'1s-60%'
	'77-200%'
	'2m 30s - 999%'
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
	[1s+notAnAdjustment%]='+notAnAdjustment%'
	[1s +not a duration%]='+not a duration%'
	[1s+1x%]='+1x%'
	[1h + what%]='+what%'
	[1h -x%]='-x%'
	[1h + 15x%]='+15x%'
	[1h + 15 %]='+15 %'
	[1h + 0.15%]='+0.15%'
    )

    for notAnAdjustment in "${!notAdjustments[@]}"
    do
	run -1 durationWithAdjustmentToSeconds -- "$notAnAdjustment" \
	    && assert_output "ERROR: Illegal ADJUSTMENT-TIMESPAN: ${notAdjustments["$notAnAdjustment"]}" \
	    || fail "${notAnAdjustment@Q}"
    done
}
