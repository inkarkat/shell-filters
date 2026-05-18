#!/usr/bin/env bats

load fixture

@test "passed durations and percentages are converted to seconds and percentage" {
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
	run -0 parseTimespanWithAdjustment -- "$duration" \
	    && assert_output "${durations["$duration"]}" \
	    || fail "$duration"
    done
}

@test "invalid adjustments exit 1 and print error message" {
    typeset -A notAdjustments=(
	[1s+notAnAdjustment%]='notAnAdjustment%'
	[1s +not a duration%]='not a duration%'
	[1s+1x%]='1x%'
	[1h + what%]='what%'
	[1h -x%]='x%'
	[1h + 15x%]='15x%'
	[1h + 15 %]='15 %'
	[1h + 0.15%]='0.15%'
    )

    for notAnAdjustment in "${!notAdjustments[@]}"
    do
	run -1 parseTimespanWithAdjustment -- "$notAnAdjustment" \
	    && assert_output "ERROR: Illegal ADJUSTMENT-TIMESPAN: ${notAdjustments["$notAnAdjustment"]}" \
	    || fail "${notAnAdjustment@Q}"
    done
}
