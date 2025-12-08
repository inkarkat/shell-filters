#!/bin/bash

load fixture

readonly SIMPLE_INPUT="Just some text.
This has foo in it.
All simple lines.
More foooo here.
Seriously."

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
    assert_equal "$logContents" "${1?}"
}
