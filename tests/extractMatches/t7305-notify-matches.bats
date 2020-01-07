#!/usr/bin/env bats

export EXTRACTMATCHES_NOTIFY_UPDATE_DELAY=-3
load notify

@test "single match with default notify command-line" {
    # The test fixture overrides EXTRACTMATCHES_NOTIFY_COMMANDLINE to remove the
    # default {FNR}, so that a constant $PREFIX can be used.
    # Undo this here to cover the default definition.
    unset EXTRACTMATCHES_NOTIFY_COMMANDLINE
    export EXTRACTMATCHES_NOTIFY_SEND="${BATS_TEST_DIRNAME}/notify.bash"	# Invoke the fixture as the test dummy.

    run extractMatches --to notify --regexp 'foo[0-9]+' <<<"$DELAY_INPUT"
    assert_runs "extractMatches -:3 -- foo3
extractMatches -:6 -- foo6
extractMatches -:9 -- foo8" ]
}

@test "single matches in a line are notify-sent every 3 lines and at the end" {
    run extractMatches --to notify --regexp 'foo[0-9]+' <<<"$DELAY_INPUT"
    [ "$output" = "$DELAY_INPUT" ]
    assert_runs "${PREFIX}foo3
${PREFIX}foo6
${PREFIX}foo8" ]
}

@test "a match on last line 6 is not notify-sent again" {
    input="Just some text.
This has foo2 in it.
All foo3.
More foo4 here.
That foo5.
Last foo6."
    run extractMatches --to notify --regexp 'foo[0-9]+' <<<"$input"
    [ "$output" = "$input" ]
    assert_runs "${PREFIX}foo3
${PREFIX}foo6" ]
}
