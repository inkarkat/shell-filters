#!/usr/bin/env bats

load fixture

@test "no input" {
    runBothCommandsWithInputEOF ''
    [ $status -eq 0 ]
    [ "${output%EOF}" = "" ]
}

@test "single empty line" {
    runBothCommandsWithInputEOF $'\n'
    [ $status -eq 0 ]
    [ "${output%EOF}" = "F:
" ]
}

@test "single line" {
    runBothCommandsWithInputEOF $'one\n'
    [ $status -eq 0 ]
    [ "${output%EOF}" = "F:one
" ]
}

@test "two lines" {
    runBothCommandsWithInputEOF $'one\ntwo\n'
    [ $status -eq 0 ]
    [ "${output%EOF}" = "F:one
R:two
" ]
}

@test "three lines" {
    runBothCommandsWithInputEOF $'one\ntwo\nthree\n'
    [ $status -eq 0 ]
    [ "${output%EOF}" = "F:one
R:two
R:three
" ]
}
