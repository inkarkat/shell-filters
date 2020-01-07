#!/bin/bash

if [ "$RUNS" ]; then
    # Invoked by the application-under-test
    printf %s\\n "$*" >> "$RUNS"
    exit 0
fi
export EXTRACTMATCHES_NOTIFY_SEND="${BASH_SOURCE[0]}"	# Invoke ourselves as the test dummy.
export RUNS="${BATS_TMPDIR}/runs"

readonly PREFIX='extractMatches {FILENAME} -- '

readonly SIMPLE_INPUT="Just some sexy text.
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

setup() {
    rm -f "$RUNS"
}

assert_runs() {
    local runsContents="$(< "$RUNS")"
    [ "$runsContents" = "${1?}" ]
}

dump_runs() {
    local runsContents="$(prefix '#' "$RUNS")"
    printf >&3 '%s\n' "$runsContents"
}
