#!/bin/bash

inputWrapper()
{
    local input="$1"; shift
    local status
    printf %s "$input" | "$@"; status=$?
    printf EOF	# " Use "${output%EOF}" in assertions.
    return $status
}
runWithInput()
{
    run inputWrapper "$@"
}

defineCommands()
{
    firstCommand=(--first-exec sed -e 's/^/F:/' \;)
    restCommand=(--rest-exec sed -e 's/^/R:/' \;)
}

runFirstCommandWithInput()
{
    defineCommands
    local input="$1"; shift
    runWithInput "$input" firstRestLines "${firstCommand[@]}" "$@"
}

runRestCommandWithInput()
{
    defineCommands
    local input="$1"; shift
    runWithInput "$input" firstRestLines "${restCommand[@]}" "$@"
}

runBothCommandsWithInput()
{
    defineCommands
    local input="$1"; shift
    runWithInput "$input" firstRestLines "${firstCommand[@]}" "${restCommand[@]}" "$@"
}
