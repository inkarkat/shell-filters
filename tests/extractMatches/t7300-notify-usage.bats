#!/usr/bin/env bats

load fixture

@test "error when custom notify-send application cannot be found" {
    export EXTRACTMATCHES_NOTIFY_SEND=/nonExistingNotifySend
    run -2 extractMatches --to notify --regexp 'foo[0-9]+'
    assert_output "ERROR: notify-send command (${EXTRACTMATCHES_NOTIFY_SEND}) not found."
}

@test "no error when custom notify-send application cannot be found but a command-line is defined" {
    export EXTRACTMATCHES_NOTIFY_SEND=/nonExistingNotifySend
    export EXTRACTMATCHES_NOTIFY_COMMANDLINE='true {}'
    extractMatches --to notify --regexp 'foo[0-9]+' <<<"this foo1"
}
