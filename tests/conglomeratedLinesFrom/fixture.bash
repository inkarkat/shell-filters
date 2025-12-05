#!/bin/bash

bats_require_minimum_version 1.5.0
bats_load_library bats-support
bats_load_library bats-assert

export LC_ALL=C TZ=Etc/UTC
export XDG_DATA_HOME="$BATS_TMPDIR"

fixtureSetup()
{
    rm -rf -- "${BATS_TMPDIR:?}/conglomeratedLinesFrom"
}
setup()
{
    fixtureSetup
}

runAnimals()
{
    run conglomeratedLinesFrom "$@" -- dishOutSections --wrap --basedir "$BATS_TEST_TMPDIR" -- "${BATS_TEST_DIRNAME}/animals.txt"
}
