#!/bin/bash

export EXTRACTMATCHES_SINK=/dev/stdout

readonly R='[s[1;1H[37;44m['
readonly N='][0m[u'

readonly SIMPLE_INPUT="Just some text.
This has foo in it.
All simple lines.
More foooo here.
Seriously."
