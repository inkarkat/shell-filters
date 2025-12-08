#!/usr/bin/env bats

load fixture

@test "error when no command is defined" {
    run -2 extractMatches --to command --regexp fo+
    assert_output 'ERROR: Command reporting must define EXTRACTMATCHES_COMMANDLINE.'
}

@test "the error from a pre-command failure is returned" {
    export EXTRACTMATCHES_COMMANDLINE="true"
    export EXTRACTMATCHES_PRE_COMMANDLINE="exit 42"
    run -42 extractMatches --to command --regexp fo+
}
@test "the error from a post-command failure is returned" {
    export EXTRACTMATCHES_COMMANDLINE="true"
    export EXTRACTMATCHES_POST_COMMANDLINE="exit 43"
    run -43 extractMatches --to command --regexp fo+ <<'EOF'
Nothing to see.
EOF
}
