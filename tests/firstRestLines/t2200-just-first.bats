#!/usr/bin/env bats

load fixture

@test "no input through first" {
    runFirstCommandWithInput ''
    [ $status -eq 0 ]
    [ "${output%EOF}" = "" ]
}

@test "single empty line through first" {
    runFirstCommandWithInput $'\n'
    [ $status -eq 0 ]
    [ "${output%EOF}" = "F:
" ]
}

@test "single line through first" {
    runFirstCommandWithInput $'one\n'
    [ $status -eq 0 ]
    [ "${output%EOF}" = "F:one
" ]
}

@test "two lines through first" {
    runFirstCommandWithInput $'one\ntwo\n'
    [ $status -eq 0 ]
    [ "${output%EOF}" = "F:one
two
" ]
}

@test "three lines through first" {
    runFirstCommandWithInput $'one\ntwo\nthree\n'
    [ $status -eq 0 ]
    [ "${output%EOF}" = "F:one
two
three
" ]
}
