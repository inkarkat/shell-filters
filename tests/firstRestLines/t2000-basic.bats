#!/usr/bin/env bats

load fixture

@test "no input" {
    runBothCommandsWithInputEOF -0 ''
    output="${output%EOF}" assert_output ''
}

@test "single empty line" {
    runBothCommandsWithInputEOF -0 $'\n'
    output="${output%EOF}" assert_output "F:
"
}

@test "single line" {
    runBothCommandsWithInputEOF -0 $'one\n'
    output="${output%EOF}" assert_output "F:one
"
}

@test "two lines" {
    runBothCommandsWithInputEOF -0 $'one\ntwo\n'
    output="${output%EOF}" assert_output "F:one
R:two
"
}

@test "three lines" {
    runBothCommandsWithInputEOF -0 $'one\ntwo\nthree\n'
    output="${output%EOF}" assert_output "F:one
R:two
R:three
"
}
