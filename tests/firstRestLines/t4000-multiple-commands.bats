#!/usr/bin/env bats

load fixture

@test "multiple commands are joined in a pipeline" {
    runBothCommandsWithInputEOF -0 $'one\ntwo\nthree\n' --first-exec sed -e 's/.*/[&]/' \; --rest-exec sed -e 's/.*/{&}/' \;
    output="${output%EOF}" assert_output "[F:one]
{R:two}
{R:three}
"
}
