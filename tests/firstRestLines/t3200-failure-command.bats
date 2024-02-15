#!/usr/bin/env bats

load fixture

@test "lines with failing first command executes fail-command instead of rest-command" {
    runRestCommandWithInput $'one\ntwo\nthree\n' --first-command false --fail-exec sed -e 's/^/X:/' \;
    [ $status -eq 1 ]
    [ "${output%EOF}" = "X:two
X:three
" ]
}

@test "failing fail-command exit status is ignored" {
runRestCommandWithInput $'one\ntwo\nthree\n' --first-command false --fail-command '(exit 33)'
    [ $status -eq 1 ]
    [ "${output%EOF}" = "" ]
}
