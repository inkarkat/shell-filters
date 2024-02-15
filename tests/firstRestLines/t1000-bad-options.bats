#!/usr/bin/env bats

@test "combination of --abort-on-failure and --fail-command is not allowed" {
    run firstRestLines --abort-on-failure --fail-command true
    [ "$status" -eq 2 ]
    [ "${lines[0]}" = "ERROR: --abort-on-failure and -x|--fail-command|--fail-exec are mutually exclusive." ]
    [ "${lines[1]%% *}" = "Usage:" ]
}
