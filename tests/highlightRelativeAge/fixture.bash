#!/bin/bash

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
    run inputWrapper "$@"
}
