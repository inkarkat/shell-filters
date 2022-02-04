#!/bin/bash

inputWrapper()
{
    local input="$1"; shift
    printf '%s\n' "$input" | "$@"
}
runWithInput()
{
    run inputWrapper "$@"
}
