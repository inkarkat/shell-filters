#!/usr/bin/env bats

export EXTRACTMATCHES_FILE_UPDATE_MATCH_DELAY=0
export EXTRACTMATCHES_FILE_UPDATE_COUNT_DELAY=0

load log

@test "single matches in a line are written to a file" {
    input="Just some text.
This has foo in it.
All simple lines.
More foo here.
Seriously."
    run -0 extractMatches --to "$LOG" --regexp fo+ <<<"$input"
    assert_output "$input"
    assert_log "foo
foo"
}

@test "three different matches with different single / global are written to a file" {
    input="Just some sexy text.
This has foo, foo and foofoo in it.
All simple lines.
More foo here.
Seriously, why?"
    run -0 extractMatches --to "$LOG" --regexp fo+ --global --regexp 'ex' --regexp 'y' --global <<<"$input"
    assert_output "$input"
    assert_log "ex
y
foo
foo
foo
foo
foo
y
y"
}
