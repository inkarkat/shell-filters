#!/usr/bin/env bats

load fixture

@test "passed durations are converted to seconds" {
    typeset -A durations=(
	[1s]=1
	[1m]=60
	[1h]=3600
	[1d]=86400
	[1w]=604800
	[1mo]=2628000
	[1y]=31536000
	[1g]=946708560
	[2h 30m]=9000
	[02:30]=150
	[1h 15m 30s]=4530
	[01:15:30]=4530
	[1d 15m]=87300
	[0g 0y 0mo 0w 0d 1h 15m 30s]=4530
	[0g 0y 0mo 0w 0d 0h 0m 0s]=0
	[1y 2mo 3w 4d 5h 6m 7s]=38970367
	[8g 7y 6mo 5w 4d 3h 2m 1s]=7813569001
	[2y 3w 16:42]=64887402
    )

    for duration in "${!durations[@]}"
    do
	run -0 durationWithAdjustmentToSeconds "$duration" \
	    && assert_output "${durations["$duration"]}" \
	    || fail "$duration"
    done
}

@test "invalid durations exit 1 and produce no output" {
    typeset -a notDurations=(
	notADuration
	'not a duration'
	1x
	'1h and what'
	'1h 42'
	'1h 15x'
	'10s 1m'
	01:15:30:55
	01.123
	'1d 15m 2h'
	'1s 15m 2h'
    )

    for notADuration in "${notDurations[@]}"
    do
	run -1 durationWithAdjustmentToSeconds "$notADuration" \
	    && assert_output "ERROR: Illegal TIMESPAN: $notADuration" \
	    || fail "$notADuration"
    done
}
