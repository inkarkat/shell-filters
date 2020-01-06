#!/usr/bin/env bats

export EXTRACTMATCHES_COMMAND_UPDATE_DELAY=0
load command

printf -v EXTRACTMATCHES_PRE_COMMANDLINE 'echo PRE >> %q' "$RUNS"
export EXTRACTMATCHES_PRE_COMMANDLINE
printf -v EXTRACTMATCHES_POST_COMMANDLINE 'echo POST >> %q' "$RUNS"
export EXTRACTMATCHES_POST_COMMANDLINE

@test "pre and post commands are executed around reporting" {
    run extractMatches --to command --regexp fo+ <<<"$SIMPLE_INPUT"
    assert_runs "PRE
foo
foooo
POST"
}
