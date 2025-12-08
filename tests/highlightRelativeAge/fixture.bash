#!/bin/bash

bats_require_minimum_version 1.5.0
bats_load_library bats-support
bats_load_library bats-assert

inputWrapper()
{
    local color="${1?}"; shift
    local colorEnd="${color:+[0m}"
    printf '%s%s%s\n' \
	    "$color" '3 minutes ago I was here' "$colorEnd" \
	    "$color" '5 months ago it broke' "$colorEnd" \
	    "$color" 'Warning: (10 days ago) It finally happened.' "$colorEnd" \
	    "$color" 'That happened recently (1 minute ago)' "$colorEnd" \
	| "$@"
}
runWithInput()
{
    typeset -a runArg=()
    if [ "$1" = '!' ] || [[ "$1" =~ ^-[0-9]+$ ]]; then
	runArg=("$1"); shift
    fi
    run "${runArg[@]}" inputWrapper "$@"
}
