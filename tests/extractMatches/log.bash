#!/bin/bash

readonly LOG="${BATS_TMPDIR}/log"
setup() {
    rm -f "$LOG"
}

assert_log() {
    local logContents="$(< "$LOG")"
    [ "$logContents" = "${1?}" ]
}
