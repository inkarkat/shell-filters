#!/usr/bin/env bats

load fixture

@test "no input with 2-count" {
    runBothCommandsWithInput '' --count 2
    [ $status -eq 0 ]
    [ "${output%EOF}" = "" ]
}

@test "single line with 2-count" {
    runBothCommandsWithInput $'one\n' --count 2
    [ $status -eq 0 ]
    [ "${output%EOF}" = "F:one
" ]
}

@test "two lines with 2-count" {
    runBothCommandsWithInput $'one\ntwo\n' --count 2
    [ $status -eq 0 ]
    [ "${output%EOF}" = "F:one
F:two
" ]
}

@test "three lines with 2-count" {
    runBothCommandsWithInput $'one\ntwo\nthree\n' --count 2
    [ $status -eq 0 ]
    [ "${output%EOF}" = "F:one
F:two
R:three
" ]
}

@test "four lines with 2-count" {
    runBothCommandsWithInput $'one\ntwo\nthree\nfour\n' --count 2
    [ $status -eq 0 ]
    [ "${output%EOF}" = "F:one
F:two
R:three
R:four
" ]
}
