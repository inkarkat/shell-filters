#!/usr/bin/env bats

load fixture

@test "lines with failing first command aborts with --abort-on-failure" {
    runRestCommandWithInputEOF -1 $'one\ntwo\nthree\n' --first-command false --abort-on-failure
    output="${output%EOF}" assert_output ''
}
