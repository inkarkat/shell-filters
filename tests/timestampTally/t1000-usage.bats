#!/usr/bin/env bats

@test "invalid option prints message and usage instructions" {
  run timestampTally --invalid-option
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: Unknown option "--invalid-option"!' ]
    [ "${lines[1]%% *}" = 'Usage:' ]
}

@test "-h prints long usage help" {
  run timestampTally -h
    [ $status -eq 0 ]
    [ "${lines[0]%% *}" != 'Usage:' ]
}

@test "invalid max difference value prints message" {
    run timestampTally --max-difference notADuration
    [ $status -eq 2 ]
    [ "$output" = 'ERROR: Illegal duration: notADuration' ]
}

@test "invalid --keep-timestamp prints message and usage instructions" {
    run timestampTally --keep-timestamp notRight
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: Invalid value for --keep-timestamp: notRight' ]
    [ "${lines[1]%% *}" = 'Usage:' ]
}

@test "--max-record-duration without --max-difference prints message and usage instructions" {
    run timestampTally --max-record-duration 1
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: --max-record-duration can only be used together with --max-difference.' ]
    [ "${lines[1]%% *}" = 'Usage:' ]
}

@test "--max-record-length without --max-difference prints message and usage instructions" {
    run timestampTally --max-record-length 1
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: --max-record-length can only be used together with --max-difference.' ]
    [ "${lines[1]%% *}" = 'Usage:' ]
}

@test "--tally and --summarize print message and usage instructions" {
    run timestampTally --tally FOO --summarize BAR
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: Cannot combine --tally with --summarize.' ]
    [ "${lines[1]%% *}" = 'Usage:' ]
}

@test "--summarize in combination with --keep-timestamp both-separate prints message and usage instructions" {
    run timestampTally --summarize FOO --keep-timestamp both-separate
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: Cannot combine --keep-timestamp both-separate with --summarize.' ]
    [ "${lines[1]%% *}" = 'Usage:' ]
}
