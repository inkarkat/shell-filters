#!/usr/bin/env bats

load fixture

@test "no input through first" {
    runFirstCommandWithInputEOF -0 ''
    output="${output%EOF}" assert_output ''
}

@test "single empty line through first" {
    runFirstCommandWithInputEOF -0 $'\n'
    output="${output%EOF}" assert_output "F:
"
}

@test "single line through first" {
    runFirstCommandWithInputEOF -0 $'one\n'
    output="${output%EOF}" assert_output "F:one
"
}

@test "two lines through first" {
    runFirstCommandWithInputEOF -0 $'one\ntwo\n'
    output="${output%EOF}" assert_output "F:one
two
"
}

@test "three lines through first" {
    runFirstCommandWithInputEOF -0 $'one\ntwo\nthree\n'
    output="${output%EOF}" assert_output "F:one
two
three
"
}
