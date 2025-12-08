#!/bin/bash

if [ $# -gt 1 ]; then
    # Invoked by the application-under-test
    printf %s\\n "$*" >> "$RUNS"
    exit 0
fi

load fixture

export EXTRACTMATCHES_NOTIFY_COMMANDLINE="\"${BASH_SOURCE[0]}\" \"extractMatches {FILENAME}\" -- {}"
export RUNS="${BATS_TMPDIR}/runs"

readonly PREFIX='extractMatches - -- '

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
    assert_equal "$runsContents" "${1?}"
}
