#!/usr/bin/env bats

load fixture

@test "no input through rest" {
    runRestCommandWithInputEOF ''
    [ $status -eq 0 ]
    [ "${output%EOF}" = "" ]
}

@test "single empty line through rest" {
    runRestCommandWithInputEOF $'\n'
    [ $status -eq 0 ]
    [ "${output%EOF}" = "
" ]
}

@test "single line through rest" {
    runRestCommandWithInputEOF $'one\n'
    [ $status -eq 0 ]
    [ "${output%EOF}" = "one
" ]
}

@test "two lines through rest" {
    runRestCommandWithInputEOF $'one\ntwo\n'
    [ $status -eq 0 ]
    [ "${output%EOF}" = "one
R:two
" ]
}

@test "three lines through rest" {
    runRestCommandWithInputEOF $'one\ntwo\nthree\n'
    [ $status -eq 0 ]
    [ "${output%EOF}" = "one
R:two
R:three
" ]
}
