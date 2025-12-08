#!/bin/bash

bats_require_minimum_version 1.5.0
bats_load_library bats-support
bats_load_library bats-assert

wrapper()
{
    local status
    "$@"; status=$?
    printf EOF	# " Use "${output%EOF}" in assertions.
    return $status
}
runWithEOF()
{
    typeset -a runArg=()
    if [ "$1" = '!' ] || [[ "$1" =~ ^-[0-9]+$ ]]; then
	runArg=("$1"); shift
    fi
    run "${runArg[@]}" wrapper "$@"
}
