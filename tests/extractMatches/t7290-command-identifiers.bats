#!/usr/bin/env bats

export EXTRACTMATCHES_COMMAND_UPDATE_DELAY=-3
load command

@test "include FILENAME with stdin in the command invocation" {
    printf -v EXTRACTMATCHES_COMMANDLINE 'printf %%s/%%s\\\\n {FILENAME} {} >> %q' "$RUNS"
    run extractMatches --to command --regexp fo+ --count '\<\w{4}\>' --global --match-count '\<i\w\>' --global <<<"$DELAY_INPUT"
    [ "$output" = "$DELAY_INPUT" ]
    assert_runs "-/This:4|in:1|it:1|foo
-/That:7|in:1|it:1|foo
-/Last:9|in:1|it:1|foo" ]
}

@test "include FILENAME with an actual file in the command invocation" {
    printf -v EXTRACTMATCHES_COMMANDLINE 'printf %%s\\ %%s\\\\n {FILENAME} {} >> %q' "$RUNS"
    TEST_FILE="${BATS_TEST_DIRNAME}/simple.txt"
    run extractMatches --to command --regexp fo+ --count '\<\w{4}\>' --global --match-count '\<i\w\>' --global "$TEST_FILE"
    assert_runs "${TEST_FILE} This:5|in:1|it:1|foo
$TEST_FILE here:7|in:1|it:1|foooo" ]
}

@test "include FNR in the command invocation" {
    printf -v EXTRACTMATCHES_COMMANDLINE 'printf %%s:%%s\\\\n {FNR} {} >> %q' "$RUNS"
    run extractMatches --to command --regexp fo+ --count '\<\w{4}\>' --global --match-count '\<i\w\>' --global <<<"$DELAY_INPUT"
    [ "$output" = "$DELAY_INPUT" ]
    assert_runs "3:This:4|in:1|it:1|foo
6:That:7|in:1|it:1|foo
9:Last:9|in:1|it:1|foo" ]
}

@test "include FILENAME and FNR in the command invocation" {
    printf -v EXTRACTMATCHES_COMMANDLINE 'printf %%s\\ %%s\\\\n {FILENAME}:{FNR} {} >> %q' "$RUNS"
    run extractMatches --to command --regexp fo+ --count '\<\w{4}\>' --global --match-count '\<i\w\>' --global <<<"$DELAY_INPUT"
    [ "$output" = "$DELAY_INPUT" ]
    assert_runs "-:3 This:4|in:1|it:1|foo
-:6 That:7|in:1|it:1|foo
-:9 Last:9|in:1|it:1|foo" ]
}

@test "reconfigure report, FILENAME and FNR in the command invocation" {
    export EXTRACTMATCHES_REPORT_MARKER='/\'
    export EXTRACTMATCHES_FILE_MARKER='[F]'
    export EXTRACTMATCHES_LINE_NUMBER_MARKER='+N+'
    printf -v EXTRACTMATCHES_COMMANDLINE "printf %%s\\\\ %%s\\\\\\\\n ${EXTRACTMATCHES_FILE_MARKER}:${EXTRACTMATCHES_LINE_NUMBER_MARKER} $EXTRACTMATCHES_REPORT_MARKER >> %q" "$RUNS"

    run extractMatches --to command --regexp fo+ --count '\<\w{4}\>' --global --match-count '\<i\w\>' --global <<<"$DELAY_INPUT"
    [ "$output" = "$DELAY_INPUT" ]
    assert_runs "-:3 This:4|in:1|it:1|foo
-:6 That:7|in:1|it:1|foo
-:9 Last:9|in:1|it:1|foo" ]
}
