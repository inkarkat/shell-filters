#!/usr/bin/env bats

timestampTallyStdout()
{
    timestampTally 2>/dev/null "$@"
}
timestampTallyStderr()
{
    timestampTally 2>&1 >/dev/null "$@"
}

@test "lines without timestamp are redirected to stderr" {
    input="this has no time
1593871643 foo
1593871644 bar
this also is odd
as is this
1593871648 baz
and the last one as well"

    run timestampTallyStdout <<<"$input"

    [ $status -eq 0 ]
    [ "$output" = "1593871643 foo
1593871644 bar
1593871648 baz" ]

    run timestampTallyStderr <<<"$input"

    [ $status -eq 0 ]
    [ "$output" = "this has no time
this also is odd
as is this
and the last one as well" ]
}
