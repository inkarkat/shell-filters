#!/usr/bin/env bats

load fixture

@test "invalid option prints message and usage instructions" {
    run -2 globToRegexp --invalid-option
    assert_line -n 0 'ERROR: Unknown option "--invalid-option"!'
    assert_line -n 2 -e '^Usage:'
}

@test "-h prints long usage help" {
    run -0 globToRegexp -h
    refute_line -n 0 -e '^Usage:'
}
