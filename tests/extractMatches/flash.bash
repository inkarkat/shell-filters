#!/bin/bash

export EXTRACTMATCHES_FLASH_ON_TIME=0
export EXTRACTMATCHES_FLASH_OFF_TIME=0
export EXTRACTMATCHES_FLASH_REPEATS=1

readonly R='[07m'
readonly N='[0m'

readonly EOL="    "
readonly FOO_M="${R}foo${N}foo"
readonly FOO_C1="${R}foo (1)${N}foo"
readonly FOO_C2="${R}foo (2)${N}foo"
readonly FOO_C3="${R}foo (3)${N}foo"
readonly FOO_C4="${R}foo (4)${N}foo"
readonly FOO_C5="${R}foo (5)${N}foo"
readonly FOOOO_M="${R}foooo${N}foooo"
readonly FOOOO_C1="${R}foooo (1)${N}foooo"
readonly X1="${R}x (1)${N}x (1)"
readonly X1f="${R}x (1)${N}x"
readonly FOO1="${R}foo (1)${N}foo (1)"
readonly FOO1f="${R}foo (1)${N}foo"
readonly FOO2="${R}foo (2)${N}foo (2)"
readonly FOO2f="${R}foo (2)${N}foo"
readonly FOO3="${R}foo (3)${N}foo (3)"
readonly FOO3f="${R}foo (3)${N}foo"
readonly FOO4="${R}foo (4)${N}foo (4)"
readonly FOO4f="${R}foo (4)${N}foo"
