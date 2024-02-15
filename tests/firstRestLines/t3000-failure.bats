#!/usr/bin/env bats

load fixture

@test "lines with failing first command" {
    runRestCommandWithInputEOF $'one\ntwo\nthree\n' --first-command false
    [ $status -eq 1 ]
    [ "${output%EOF}" = "R:two
R:three
" ]
}

@test "lines with failing rest command" {
runFirstCommandWithInputEOF $'one\ntwo\nthree\n' --rest-command '(exit 5)'
    [ $status -eq 5 ]
    [ "${output%EOF}" = "F:one
" ]
}

@test "lines with both commands failing returns failure of first" {
runWithInputEOF $'one\ntwo\nthree\n' firstRestLines --first-command false --rest-command '(exit 5)'
    [ $status -eq 1 ]
    [ "${output%EOF}" = "" ]
}
