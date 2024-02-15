#!/usr/bin/env bats

load fixture

@test "no input" {
    runBothCommandsWithInput ''
    [ $status -eq 0 ]
    [ "${output%EOF}" = "" ]
}

@test "single empty line" {
    runBothCommandsWithInput $'\n'
    [ $status -eq 0 ]
    [ "${output%EOF}" = "F:
" ]
}

@test "single line" {
    runBothCommandsWithInput $'one\n'
    [ $status -eq 0 ]
    [ "${output%EOF}" = "F:one
" ]
}

@test "two lines" {
    runBothCommandsWithInput $'one\ntwo\n'
    [ $status -eq 0 ]
    [ "${output%EOF}" = "F:one
R:two
" ]
}

@test "three lines" {
    runBothCommandsWithInput $'one\ntwo\nthree\n'
    [ $status -eq 0 ]
    [ "${output%EOF}" = "F:one
R:two
R:three
" ]
}
