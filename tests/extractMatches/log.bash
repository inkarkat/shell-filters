#!/bin/bash

readonly DELAY_INPUT="Just sexy text.
This has foo2 in it.
All foo3.
More foo4 here.
That foo5.
Rex' foo6.
Your foo7.
Last foo8.
Seriously."

readonly LOG="${BATS_TMPDIR}/log"
setup() {
    rm -f "$LOG"
}

assert_log() {
    local logContents="$(< "$LOG")"
    [ "$logContents" = "${1?}" ]
}

dump_log() {
    local logContents="$(< "$LOG")"
    printf >&3 '%s\n' "$logContents"
}
