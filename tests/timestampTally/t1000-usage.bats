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
