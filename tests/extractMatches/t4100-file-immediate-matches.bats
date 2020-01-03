#!/usr/bin/env bats

load log

@test "single matches in a line are written to a file" {
    input="Just some text.
This has foo in it.
All simple lines.
More foo here.
Seriously."
    run extractMatches --unbuffered --to "$LOG" --regexp fo+ <<<"$input"
    [ "$output" = "$input" ]
    assert_log "foo
foo" ]
}

@test "three different matches with different single / global are written to a file" {
    input="Just some sexy text.
This has foo, foo and foofoo in it.
All simple lines.
More foo here.
Seriously, why?"
    run extractMatches --unbuffered --to "$LOG" --regexp fo+ --global --regexp 'ex' --regexp 'y' --global <<<"$input"
    [ "$output" = "$input" ]
    assert_log "ex
y
foo
foo
foo
foo
foo
y
y" ]
}
