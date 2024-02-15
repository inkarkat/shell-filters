#!/usr/bin/env bats

load fixture

@test "no input through rest" {
    runRestCommandWithInput ''
    [ $status -eq 0 ]
    [ "${output%EOF}" = "" ]
}

@test "single empty line through rest" {
    runRestCommandWithInput $'\n'
    [ $status -eq 0 ]
    [ "${output%EOF}" = "
" ]
}

@test "single line through rest" {
    runRestCommandWithInput $'one\n'
    [ $status -eq 0 ]
    [ "${output%EOF}" = "one
" ]
}

@test "two lines through rest" {
    runRestCommandWithInput $'one\ntwo\n'
    [ $status -eq 0 ]
    [ "${output%EOF}" = "one
R:two
" ]
}

@test "three lines through rest" {
    runRestCommandWithInput $'one\ntwo\nthree\n'
    [ $status -eq 0 ]
    [ "${output%EOF}" = "one
R:two
R:three
" ]
}
