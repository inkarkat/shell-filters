#!/bin/bash

bats_require_minimum_version 1.5.0
bats_load_library bats-support
bats_load_library bats-assert

inputWrapper()
{
    local input="$1"; shift
    local status
    printf %s "$input" | "$@"; status=$?
    printf EOF	# " Use "${output%EOF}" in assertions.
    return $status
}
runWithInputEOF()
{
    typeset -a runArg=()
    if [ "$1" = '!' ] || [[ "$1" =~ ^-[0-9]+$ ]]; then
	runArg=("$1"); shift
    fi
    run "${runArg[@]}" inputWrapper "$@"
}

defineCommands()
{
    firstCommand=(--first-exec sed -e 's/^/F:/' \;)
    restCommand=(--rest-exec sed -e 's/^/R:/' \;)
}

runFirstCommandWithInputEOF()
{
    defineCommands
    typeset -a runArg=()
    if [ "$1" = '!' ] || [[ "$1" =~ ^-[0-9]+$ ]]; then
	runArg=("$1"); shift
    fi
    local input="$1"; shift
    runWithInputEOF "${runArg[@]}" "$input" firstRestLines "${firstCommand[@]}" "$@"
}

runRestCommandWithInputEOF()
{
    defineCommands
    typeset -a runArg=()
    if [ "$1" = '!' ] || [[ "$1" =~ ^-[0-9]+$ ]]; then
	runArg=("$1"); shift
    fi
    local input="$1"; shift
    runWithInputEOF "${runArg[@]}" "$input" firstRestLines "${restCommand[@]}" "$@"
}

runBothCommandsWithInputEOF()
{
    defineCommands
    typeset -a runArg=()
    if [ "$1" = '!' ] || [[ "$1" =~ ^-[0-9]+$ ]]; then
	runArg=("$1"); shift
    fi
    local input="$1"; shift
    runWithInputEOF "${runArg[@]}" "$input" firstRestLines "${firstCommand[@]}" "${restCommand[@]}" "$@"
}
