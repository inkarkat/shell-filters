#!/usr/bin/env bats

readonly LOG="${BATS_TMPDIR}/log"
setup() {
    rm -f "$LOG"
}

@test "single matches in a line are written to a file" {
    input="Just some text.
This has foo in it.
All simple lines.
More foo here.
Seriously."
    run extractMatches --unbuffered --to "$LOG" --regexp fo+ <<<"$input"
    [ "$output" = "$input" ]
    logContents="$(< "$LOG")"; [ "$logContents" = "foo
foo" ]
}

@test "three different matches with different single / global are highlighted" {
    input="Just some sexy text.
This has foo, foo and foofoo in it.
All simple lines.
More foo here.
Seriously, why?"
    run extractMatches --unbuffered --to "$LOG" --regexp fo+ --global --regexp 'ex' --regexp 'y' --global <<<"$input"
    [ "$output" = "$input" ]
    logContents="$(< "$LOG")"; [ "$logContents" = "ex
y
foo
foo
foo
foo
foo
y
y" ]
}
