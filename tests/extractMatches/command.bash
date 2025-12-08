#!/bin/bash

load fixture

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

readonly RUNS="${BATS_TMPDIR}/runs"
setup() {
    rm -f "$RUNS"
}
printf -v EXTRACTMATCHES_COMMANDLINE 'printf %%s\\\\n {} >> %q' "$RUNS"
export EXTRACTMATCHES_COMMANDLINE

assert_runs() {
    local runsContents="$(< "$RUNS")"
    assert_equal "$runsContents" "${1?}"
}
