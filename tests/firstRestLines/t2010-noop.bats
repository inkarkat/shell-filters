#!/usr/bin/env bats

load fixture

@test "no input without commands" {
    runWithInput '' firstRestLines
    [ $status -eq 0 ]
    [ "${output%EOF}" = "" ]
}

@test "single empty line without commands just passes through" {
    runWithInput $'\n' firstRestLines
    [ $status -eq 0 ]
    [ "${output%EOF}" = "
" ]
}

@test "single line without commands just passes through" {
    runWithInput $'one\n' firstRestLines
    [ $status -eq 0 ]
    [ "${output%EOF}" = "one
" ]
}

@test "two lines without commands just passes through" {
    runWithInput $'one\ntwo\n' firstRestLines
    [ $status -eq 0 ]
    [ "${output%EOF}" = "one
two
" ]
}

@test "three lines without commands just passes through" {
    runWithInput $'one\ntwo\nthree\n' firstRestLines
    [ $status -eq 0 ]
    [ "${output%EOF}" = "one
two
three
" ]
}
