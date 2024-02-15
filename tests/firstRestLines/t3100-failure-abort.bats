#!/usr/bin/env bats

load fixture

@test "lines with failing first command aborts with --abort-on-failure" {
    runRestCommandWithInput $'one\ntwo\nthree\n' --first-command false --abort-on-failure
    [ $status -eq 1 ]
    [ "${output%EOF}" = "" ]
}
