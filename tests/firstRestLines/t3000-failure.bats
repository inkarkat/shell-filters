#!/usr/bin/env bats

load fixture

@test "lines with failing first command" {
    runRestCommandWithInput $'one\ntwo\nthree\n' --first-command false
    [ $status -eq 1 ]
    [ "${output%EOF}" = "R:two
R:three
" ]
}

@test "lines with failing rest command" {
runFirstCommandWithInput $'one\ntwo\nthree\n' --rest-command '(exit 5)'
    [ $status -eq 5 ]
    [ "${output%EOF}" = "F:one
" ]
}

@test "lines with both commands failing returns failure of first" {
runWithInput $'one\ntwo\nthree\n' firstRestLines --first-command false --rest-command '(exit 5)'
    [ $status -eq 1 ]
    [ "${output%EOF}" = "" ]
}

@test "lines with failing first command aborts with --abort-on-failure" {
    runRestCommandWithInput $'one\ntwo\nthree\n' --first-command false --abort-on-failure
    [ $status -eq 1 ]
    [ "${output%EOF}" = "" ]
}
