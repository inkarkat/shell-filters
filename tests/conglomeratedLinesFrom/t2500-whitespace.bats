#!/usr/bin/env bats

load fixture

runneeWrapper()
{
    "$@"
    local status=$?
    printf '$'
    return $status
}
runWithFullOutput()
{
    typeset -a runArg=()
    if [ "$1" = '!' ] || [[ "$1" =~ ^-[0-9]+$ ]]; then
	runArg=("$1"); shift
    fi

    run "${runArg[@]}" runneeWrapper "$@"
    output="${output%\$}"
}

runCatsAndDogsElseSedExpr()
{
    local sedExpr="${1:?}"; shift
    runWithFullOutput conglomeratedLinesFrom -- \
	pipelineBuilder \
	    --exec dishOutSections --wrap --basedir "$BATS_TEST_TMPDIR" -- "${BATS_TEST_DIRNAME}/animals.txt" \; \
	    --exec sed -e '/^cat$/b' -e '/^dog$/b' -e "$sedExpr" \;
}
runCatsAndDogsAmongEmptyLines()
{
    runCatsAndDogsElseSedExpr 's/.*//'
}
runCatsAndDogsAmongWhitespace()
{
    runCatsAndDogsElseSedExpr 'y/abcdefghijklmnopqrstuvwxyz/                          /'
}

@test "cat and dog among empty lines reporting prints empty lines immediately" {
    runCatsAndDogsAmongEmptyLines
    assert_output $'\n\n'

    runCatsAndDogsAmongEmptyLines
    assert_output $'\n'

    runCatsAndDogsAmongEmptyLines
    assert_output $'\n\ndog\n'

    runCatsAndDogsAmongEmptyLines
    assert_output $'cat\n\ndog\n\n'

    runCatsAndDogsAmongEmptyLines
    assert_output $'\n\n\n\n\n'

    runCatsAndDogsAmongEmptyLines
    assert_output $'\n\n\n'

    runCatsAndDogsAmongEmptyLines
    assert_output $'\n\n'
}

@test "cat and dog among whitespace reporting prints whitespace immediately" {
    runCatsAndDogsAmongWhitespace
    assert_output $'        \n    \n'

    runCatsAndDogsAmongWhitespace
    assert_output $'        \n'

    runCatsAndDogsAmongWhitespace
    assert_output $'   \n    \ndog\n'

    runCatsAndDogsAmongWhitespace
    assert_output $'cat\n       \ndog\n        \n'

    runCatsAndDogsAmongWhitespace
    assert_output $'        \n   \n     \n      \n         \n'

    runCatsAndDogsAmongWhitespace
    assert_output $'        \n    \n   \n'

    runCatsAndDogsAmongWhitespace
    assert_output $'        \n        \n'
}
