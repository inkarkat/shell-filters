#!/bin/bash

readonly SIMPLE_INPUT="Just some sexy text.
This has foo in it.
All simple lines.
More foooo here.
Seriously."

readonly RUNS="${BATS_TMPDIR}/runs"
setup() {
    rm -f "$RUNS"
}
printf -v EXTRACTMATCHES_COMMANDLINE 'printf %%s\\\\n {} >> %q' "$RUNS"
export EXTRACTMATCHES_COMMANDLINE

assert_runs() {
    local runsContents="$(< "$RUNS")"
    [ "$runsContents" = "${1?}" ]
}

dump_runs() {
    local runsContents="$(prefix '#' "$RUNS")"
    printf >&3 '%s\n' "$runsContents"
}
