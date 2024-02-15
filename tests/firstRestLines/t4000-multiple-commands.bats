#!/usr/bin/env bats

load fixture

@test "multiple commands are joined in a pipeline" {
    runBothCommandsWithInput $'one\ntwo\nthree\n' --first-exec sed -e 's/.*/[&]/' \; --rest-exec sed -e 's/.*/{&}/' \;
    [ $status -eq 0 ]
    [ "${output%EOF}" = "[F:one]
{R:two}
{R:three}
" ]
}
