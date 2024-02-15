#!/usr/bin/env bats

load fixture

@test "no input through first" {
    runFirstCommandWithInputEOF ''
    [ $status -eq 0 ]
    [ "${output%EOF}" = "" ]
}

@test "single empty line through first" {
    runFirstCommandWithInputEOF $'\n'
    [ $status -eq 0 ]
    [ "${output%EOF}" = "F:
" ]
}

@test "single line through first" {
    runFirstCommandWithInputEOF $'one\n'
    [ $status -eq 0 ]
    [ "${output%EOF}" = "F:one
" ]
}

@test "two lines through first" {
    runFirstCommandWithInputEOF $'one\ntwo\n'
    [ $status -eq 0 ]
    [ "${output%EOF}" = "F:one
two
" ]
}

@test "three lines through first" {
    runFirstCommandWithInputEOF $'one\ntwo\nthree\n'
    [ $status -eq 0 ]
    [ "${output%EOF}" = "F:one
two
three
" ]
}
