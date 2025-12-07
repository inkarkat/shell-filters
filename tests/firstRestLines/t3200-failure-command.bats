#!/usr/bin/env bats

load fixture

@test "lines with failing first command executes fail-command instead of rest-command" {
    runRestCommandWithInputEOF -1 $'one\ntwo\nthree\n' --first-command false --fail-exec sed -e 's/^/X:/' \;
    output="${output%EOF}" assert_output "X:two
X:three
"
}

@test "failing fail-command exit status is ignored" {
runRestCommandWithInputEOF -1 $'one\ntwo\nthree\n' --first-command false --fail-command '(exit 33)'
    output="${output%EOF}" assert_output ''
}
