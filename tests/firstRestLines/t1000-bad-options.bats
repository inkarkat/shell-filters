#!/usr/bin/env bats

load fixture

@test "combination of --abort-on-failure and --fail-command is not allowed" {
    run -2 firstRestLines --abort-on-failure --fail-command true
    assert_line -n 0 "ERROR: --abort-on-failure and -x|--fail-command|--fail-exec are mutually exclusive."
    assert_line -n 1 -e "^Usage:"
}
