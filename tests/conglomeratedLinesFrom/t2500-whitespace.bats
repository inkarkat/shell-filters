#!/usr/bin/env bats

load fixture

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

runCatsAndDogsElseSedExpr()
{
    local sedExpr="${1:?}"; shift
    runWithEOF conglomeratedLinesFrom -- \
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
    output="${output%EOF}" assert_output $'\n\n'

    runCatsAndDogsAmongEmptyLines
    output="${output%EOF}" assert_output $'\n'

    runCatsAndDogsAmongEmptyLines
    output="${output%EOF}" assert_output $'\n\ndog\n'

    runCatsAndDogsAmongEmptyLines
    output="${output%EOF}" assert_output $'cat\n\ndog\n\n'

    runCatsAndDogsAmongEmptyLines
    output="${output%EOF}" assert_output $'\n\n\n\n\n'

    runCatsAndDogsAmongEmptyLines
    output="${output%EOF}" assert_output $'\n\n\n'

    runCatsAndDogsAmongEmptyLines
    output="${output%EOF}" assert_output $'\n\n'
}

@test "cat and dog among whitespace reporting prints whitespace immediately" {
    runCatsAndDogsAmongWhitespace
    output="${output%EOF}" assert_output $'        \n    \n'

    runCatsAndDogsAmongWhitespace
    output="${output%EOF}" assert_output $'        \n'

    runCatsAndDogsAmongWhitespace
    output="${output%EOF}" assert_output $'   \n    \ndog\n'

    runCatsAndDogsAmongWhitespace
    output="${output%EOF}" assert_output $'cat\n       \ndog\n        \n'

    runCatsAndDogsAmongWhitespace
    output="${output%EOF}" assert_output $'        \n   \n     \n      \n         \n'

    runCatsAndDogsAmongWhitespace
    output="${output%EOF}" assert_output $'        \n    \n   \n'

    runCatsAndDogsAmongWhitespace
    output="${output%EOF}" assert_output $'        \n        \n'
}
