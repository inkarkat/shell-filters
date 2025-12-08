#!/usr/bin/env bats

load fixture

@test "lines with failing first command" {
    runRestCommandWithInputEOF -1 $'one\ntwo\nthree\n' --first-command false
    output="${output%EOF}" assert_output "R:two
R:three
"
}

@test "lines with failing rest command" {
    runFirstCommandWithInputEOF -5 $'one\ntwo\nthree\n' --rest-command '(exit 5)'
    output="${output%EOF}" assert_output "F:one
"
}

@test "lines with both commands failing returns failure of first" {
    runWithInputEOF -1 $'one\ntwo\nthree\n' firstRestLines --first-command false --rest-command '(exit 5)'
    output="${output%EOF}" assert_output ''
}
