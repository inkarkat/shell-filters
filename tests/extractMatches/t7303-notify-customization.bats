#!/usr/bin/env bats

export EXTRACTMATCHES_NOTIFY_UPDATE_DELAY=-3
load notify

# The test fixture overrides EXTRACTMATCHES_NOTIFY_COMMANDLINE to remove the
# default {FNR}, so that a constant $PREFIX can be used.
# Undo this here to cover the default definition.
unset EXTRACTMATCHES_NOTIFY_COMMANDLINE
export EXTRACTMATCHES_NOTIFY_SEND="${BATS_TEST_DIRNAME}/notify.bash"	# Invoke the fixture as the test dummy.

@test "single match with default notify command-line" {
    run extractMatches --to notify --regexp 'foo[0-9]+' <<<"$DELAY_INPUT"
    assert_runs "extractMatches -:3 -- foo3
extractMatches -:6 -- foo6
extractMatches -:9 -- foo8" ]
}

@test "augment default notify command-line with custom arguments" {
    export EXTRACTMATCHES_NOTIFY_ARGUMENTS="-i terminal -u low"	# Invoke the fixture as the test dummy.
    run extractMatches --to notify --regexp 'foo[0-9]+' <<<"$DELAY_INPUT"
    assert_runs "$EXTRACTMATCHES_NOTIFY_ARGUMENTS extractMatches -:3 -- foo3
$EXTRACTMATCHES_NOTIFY_ARGUMENTS extractMatches -:6 -- foo6
$EXTRACTMATCHES_NOTIFY_ARGUMENTS extractMatches -:9 -- foo8" ]
}
