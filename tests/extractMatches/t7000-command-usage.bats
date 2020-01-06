#!/usr/bin/env bats

@test "error when no command is defined" {
    run extractMatches --to command --regexp fo+
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: Command reporting must define EXTRACTMATCHES_COMMANDLINE." ]
    [ "${lines[1]%% *}" = 'Usage:' ]
}

@test "the error from a pre-command failure is returned" {
    export EXTRACTMATCHES_COMMANDLINE="true"
    export EXTRACTMATCHES_PRE_COMMANDLINE="exit 42"
    run extractMatches --to command --regexp fo+
    [ $status -eq 42 ]
}
@test "the error from a post-command failure is returned" {
    export EXTRACTMATCHES_COMMANDLINE="true"
    export EXTRACTMATCHES_POST_COMMANDLINE="exit 43"
    run extractMatches --to command --regexp fo+ <<'EOF'
Nothing to see.
EOF
    [ $status -eq 43 ]
}
