#!/bin/bash

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
    run inputWrapper "$@"
}

defineCommands()
{
    firstCommand=(--first-exec sed -e 's/^/F:/' \;)
    restCommand=(--rest-exec sed -e 's/^/R:/' \;)
}

runFirstCommandWithInputEOF()
{
    defineCommands
    local input="$1"; shift
    runWithInputEOF "$input" firstRestLines "${firstCommand[@]}" "$@"
}

runRestCommandWithInputEOF()
{
    defineCommands
    local input="$1"; shift
    runWithInputEOF "$input" firstRestLines "${restCommand[@]}" "$@"
}

runBothCommandsWithInputEOF()
{
    defineCommands
    local input="$1"; shift
    runWithInputEOF "$input" firstRestLines "${firstCommand[@]}" "${restCommand[@]}" "$@"
}
