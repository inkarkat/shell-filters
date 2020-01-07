#!/usr/bin/env bats

export EXTRACTMATCHES_COMMAND_UPDATE_DELAY=-3
load command

@test "include FILENAME in the command invocation" {
    printf -v EXTRACTMATCHES_COMMANDLINE 'printf %%s/%%s\\\\n {FILENAME} {} >> %q' "$RUNS"
    run extractMatches --to command --regexp fo+ --count '\<\w{4}\>' --global --match-count '\<i\w\>' --global <<<"$DELAY_INPUT"
    [ "$output" = "$DELAY_INPUT" ]
    assert_runs "-/This:4|in:1|it:1|foo
-/That:7|in:1|it:1|foo
-/Last:9|in:1|it:1|foo" ]
}
