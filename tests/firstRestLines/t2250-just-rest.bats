#!/usr/bin/env bats

load fixture

@test "no input through rest" {
    runRestCommandWithInputEOF -0 ''
    output="${output%EOF}" assert_output ''
}

@test "single empty line through rest" {
    runRestCommandWithInputEOF -0 $'\n'
    output="${output%EOF}" assert_output "
"
}

@test "single line through rest" {
    runRestCommandWithInputEOF -0 $'one\n'
    output="${output%EOF}" assert_output "one
"
}

@test "two lines through rest" {
    runRestCommandWithInputEOF -0 $'one\ntwo\n'
    output="${output%EOF}" assert_output "one
R:two
"
}

@test "three lines through rest" {
    runRestCommandWithInputEOF -0 $'one\ntwo\nthree\n'
    output="${output%EOF}" assert_output "one
R:two
R:three
"
}
