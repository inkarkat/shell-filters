#!/usr/bin/env bats

load fixture

@test "no input with 2-count" {
    runBothCommandsWithInputEOF -0 '' --count 2
    output="${output%EOF}" assert_output ''
}

@test "single line with 2-count" {
    runBothCommandsWithInputEOF -0 $'one\n' --count 2
    output="${output%EOF}" assert_output "F:one
"
}

@test "two lines with 2-count" {
    runBothCommandsWithInputEOF -0 $'one\ntwo\n' --count 2
    output="${output%EOF}" assert_output "F:one
F:two
"
}

@test "three lines with 2-count" {
    runBothCommandsWithInputEOF -0 $'one\ntwo\nthree\n' --count 2
    output="${output%EOF}" assert_output "F:one
F:two
R:three
"
}

@test "four lines with 2-count" {
    runBothCommandsWithInputEOF -0 $'one\ntwo\nthree\nfour\n' --count 2
    output="${output%EOF}" assert_output "F:one
F:two
R:three
R:four
"
}
