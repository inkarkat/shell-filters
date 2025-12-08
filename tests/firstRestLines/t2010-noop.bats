#!/usr/bin/env bats

load fixture

@test "no input without commands" {
    runWithInputEOF -0 '' firstRestLines
    output="${output%EOF}" assert_output ''
}

@test "single empty line without commands just passes through" {
    runWithInputEOF -0 $'\n' firstRestLines
    output="${output%EOF}" assert_output "
"
}

@test "single line without commands just passes through" {
    runWithInputEOF -0 $'one\n' firstRestLines
    output="${output%EOF}" assert_output "one
"
}

@test "two lines without commands just passes through" {
    runWithInputEOF -0 $'one\ntwo\n' firstRestLines
    output="${output%EOF}" assert_output "one
two
"
}

@test "three lines without commands just passes through" {
    runWithInputEOF -0 $'one\ntwo\nthree\n' firstRestLines
    output="${output%EOF}" assert_output "one
two
three
"
}
