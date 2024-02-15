#!/bin/bash

inputFileWrapper()
{
    local inputFile="$1"; shift
    local status
    < "$inputFile" "$@"; status=$?
    printf EOF	# " Use "${output%EOF}" in assertions.
    return $status
}
runWithInputFileEOF()
{
    run inputFileWrapper "$@"
}
