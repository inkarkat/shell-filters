#!/bin/bash

wrapper()
{
    local status
    "$@"; status=$?
    printf EOF	# " Use "${output%EOF}" in assertions.
    return $status
}
runWithEOF()
{
    run wrapper "$@"
}
