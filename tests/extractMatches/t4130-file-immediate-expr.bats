#!/usr/bin/env bats

export EXTRACTMATCHES_FILE_UPDATE_DELAY=0
load log

@test "matches and counts are written to a file with custom static prefix and suffix" {

    export EXTRACTMATCHES_FILE_PREFIX_EXPR='prefix['
    export EXTRACTMATCHES_FILE_SUFFIX_EXPR=']suffix'

    run extractMatches --to "$LOG" --regexp fo+ --count '\<\w{4}\>' --global --match-count '\<i\w\>' --global <<<"$SIMPLE_INPUT"
    [ "$output" = "$SIMPLE_INPUT" ]
    assert_log "prefix[Just: 1]suffix
prefix[some: 2]suffix
prefix[text: 3]suffix
prefix[This: 4]suffix
prefix[foo]suffix
prefix[in: 1]suffix
prefix[it: 1]suffix
prefix[More: 5]suffix
prefix[foooo]suffix
prefix[here: 6]suffix"
}

@test "matches and counts are written to a file with custom dynamic prefix and suffix" {

    export EXTRACTMATCHES_FILE_PREFIX_EXPR='${USER}['
    export EXTRACTMATCHES_FILE_SUFFIX_EXPR="]\$(cat \"$LOG\" | wc -l)"
    touch -- "$LOG" # So that the log file already exists and cat does not complain.

    # Note: Need to use --unbuffered here so that the file is immediately
    # flushed after each line.
    run extractMatches --unbuffered --to "$LOG" --regexp fo+ --count '\<\w{4}\>' --global --match-count '\<i\w\>' --global <<<"$SIMPLE_INPUT"
    [ "$output" = "$SIMPLE_INPUT" ]
    assert_log "${USER}[Just: 1]0
${USER}[some: 2]1
${USER}[text: 3]2
${USER}[This: 4]3
${USER}[foo]4
${USER}[in: 1]5
${USER}[it: 1]6
${USER}[More: 5]7
${USER}[foooo]8
${USER}[here: 6]9"
}

@test "an invalid expression prints the error" {

    export EXTRACTMATCHES_FILE_PREFIX_EXPR='$(what?['
    export EXTRACTMATCHES_FILE_SUFFIX_EXPR="]\$(cat /doesnotexist | wc -l)"

    run extractMatches --to "$LOG" --regexp fo+ --count '\<\w{4}\>' --global --match-count '\<i\w\>' --global <<<"$SIMPLE_INPUT"
    [[ "${lines[0]}" = *"Syntax error: Unterminated quoted string"* ]]
    [ "${lines[1]}" = "cat: /doesnotexist: No such file or directory" ]
    [[ "${lines[2]}" = *"Syntax error: Unterminated quoted string"* ]]
    [ "${lines[3]}" = "cat: /doesnotexist: No such file or directory" ]

    assert_log "Just: 1]0
some: 2]0
text: 3]0
This: 4]0
foo]0
in: 1]0
it: 1]0
More: 5]0
foooo]0
here: 6]0"
}

