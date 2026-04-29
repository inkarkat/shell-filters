#!/bin/bash

bats_require_minimum_version 1.5.0
bats_load_library bats-support
bats_load_library bats-assert

runWithCannedInput()
{
    run "$@" <"${BATS_TEST_DIRNAME}/input.txt"
}

inputWrapper()
{
    local input="$1"; shift
    printf "%s${input:+\n}" "$input" | "$@"
}
runWithInput()
{
    typeset -a runArg=()
    if [ "$1" = '!' ] || [[ "$1" =~ ^-[0-9]+$ ]]; then
	runArg=("$1"); shift
    fi
    run "${runArg[@]}" inputWrapper "$@"
}
