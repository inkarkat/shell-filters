#!/usr/bin/env bats

load fixture

@test "invalid option prints message and usage instructions" {
  run -2 timestampTally --invalid-option
    assert_line -n 0 'ERROR: Unknown option "--invalid-option"!'
    assert_line -n 1 -e '^Usage:'
}

@test "-h prints long usage help" {
  run -0 timestampTally -h
    refute_line -n 0 -e '^Usage:'
}

@test "invalid max difference value prints message" {
    run -2 timestampTally --max-difference notADuration
    assert_output 'ERROR: Illegal duration: notADuration'
}

@test "invalid --keep-timestamp prints message and usage instructions" {
    run -2 timestampTally --keep-timestamp notRight
    assert_line -n 0 'ERROR: Invalid value for --keep-timestamp: notRight'
    assert_line -n 1 -e '^Usage:'
}

@test "--max-record-duration without --max-difference prints message and usage instructions" {
    run -2 timestampTally --max-record-duration 1
    assert_line -n 0 'ERROR: --max-record-duration can only be used together with --max-difference.'
    assert_line -n 1 -e '^Usage:'
}

@test "--max-record-length without --max-difference prints message and usage instructions" {
    run -2 timestampTally --max-record-length 1
    assert_line -n 0 'ERROR: --max-record-length can only be used together with --max-difference.'
    assert_line -n 1 -e '^Usage:'
}

@test "--tally and --summarize print message and usage instructions" {
    run -2 timestampTally --tally FOO --summarize BAR
    assert_line -n 0 'ERROR: Cannot combine --tally with --summarize.'
    assert_line -n 1 -e '^Usage:'
}

@test "--summarize in combination with --keep-timestamp both-separate prints message and usage instructions" {
    run -2 timestampTally --summarize FOO --keep-timestamp both-separate
    assert_line -n 0 'ERROR: Cannot combine --keep-timestamp both-separate with --summarize.'
    assert_line -n 1 -e '^Usage:'
}
