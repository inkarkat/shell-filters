#!/usr/bin/env bats

export EXTRACTMATCHES_FILE_UPDATE_DELAY=0
export input="This has foo in it.
More fooo here."
load log

@test "prefix replacement of match is written to file" {
    run extractMatches --to "$LOG" --regexp fo+ --replacement "FOO: &" <<<"$input"
    assert_log "FOO: foo
FOO: fooo"
}

@test "capture group replacement of match and count is written to file" {
    run extractMatches --to "$LOG" --regexp '(f)(o+)' --replacement "\1-\2" --count '\<(\w)\w{2}(\w)\>' --replacement "\1-\2" <<<"$input"
    assert_log "T-s: 1
f-oo
M-e: 2
f-ooo"
}

@test "plain replacements of count does not affect counting, only writing to file" {
    run extractMatches --to "$LOG" --count fo+ --global --replacement "FOO" --count 'i\w' --global --replacement "FOO" <<<"$input"
    assert_log "FOO: 1
FOO: 1
FOO: 2
FOO: 3
FOO: 2"
}

@test "capture group replacements of match-count that condense characters affects counting and writing to file" {
    input="This moooo mooo moo has foo in it.
More fooo here. moooo moo"
    run extractMatches --to "$LOG" --match-count '([fm])(o)+' --global --replacement "\1\2" <<<"$input"
    assert_log "mo: 1
mo: 2
mo: 3
fo: 1
fo: 2
mo: 4
mo: 5"
}
