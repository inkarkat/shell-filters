#!/bin/bash

load fixture

fakeSeconds()
{
    DISHOUTLINES_FILENAME=fakeSeconds dishOutLines --basedir "$BATS_TEST_TMPDIR" "$@" -- <(seq 1 20)
}
export -f fakeSeconds
export SECONDSOURCE=fakeSeconds

fakeTimestamps()
{
    typeset -a timestamps=(
100.000
100.101
100.189
100.297
100.404
100.512
100.602
100.721
100.809
100.908
101.017
101.130
101.219
101.305
101.419
101.512
)
    set -- "${timestamps[@]}"
    while read -r _
    do
	printf '%s\n' "$1"; shift
    done
}
export -f fakeTimestamps
export DATE=fakeTimestamps
