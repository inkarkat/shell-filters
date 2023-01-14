#!/bin/bash

inputFileWrapper()
{
    local inputFile="$1"; shift
    < "$inputFile" "$@"
}
runWithInputFile()
{
    run inputFileWrapper "$@"
}
runWithCannedInput()
{
    runWithInputFile "${BATS_TEST_DIRNAME}/input.txt" "$@"
}

inputWrapper()
{
    local input="$1"; shift
    printf "%s${input:+\n}" "$input" | "$@"
}
runWithInput()
{
    run inputWrapper "$@"
}
