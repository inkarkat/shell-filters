#!/usr/bin/env bats

load fixture

@test "no input without commands" {
    runWithInputEOF '' firstRestLines
    [ $status -eq 0 ]
    [ "${output%EOF}" = "" ]
}

@test "single empty line without commands just passes through" {
    runWithInputEOF $'\n' firstRestLines
    [ $status -eq 0 ]
    [ "${output%EOF}" = "
" ]
}

@test "single line without commands just passes through" {
    runWithInputEOF $'one\n' firstRestLines
    [ $status -eq 0 ]
    [ "${output%EOF}" = "one
" ]
}

@test "two lines without commands just passes through" {
    runWithInputEOF $'one\ntwo\n' firstRestLines
    [ $status -eq 0 ]
    [ "${output%EOF}" = "one
two
" ]
}

@test "three lines without commands just passes through" {
    runWithInputEOF $'one\ntwo\nthree\n' firstRestLines
    [ $status -eq 0 ]
    [ "${output%EOF}" = "one
two
three
" ]
}
