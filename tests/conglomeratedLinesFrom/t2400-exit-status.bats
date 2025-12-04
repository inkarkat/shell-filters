#!/usr/bin/env bats

load fixture

runBlah()
{
    run -11 conglomeratedLinesFrom "$@" --id same -c 'echo blah; (exit 11)'
}

runBlubb()
{
    run -44 conglomeratedLinesFrom "$@" --id same -c 'echo blubb; (exit 44)'
}

runBlahBlubb()
{
    run conglomeratedLinesFrom "$@" --id same -c "printf '%s\\n' blah blubb"
}

@test "exit status from command is returned" {
    runBlah
    assert_output ''

    runBlubb
    assert_output ''

    runBlahBlubb
    assert_output ''

    runBlubb
    assert_output 'blubb'

    runBlahBlubb
    assert_output 'blubb'

    runBlah
    assert_output 'blah'

    runBlahBlubb
    assert_output - <<'EOF'
blah
blubb
EOF
}

@test "exit status from command is returned with --successful-only" {
    runBlah --successful-only
    assert_output 'blah'

    runBlubb --successful-only
    assert_output 'blubb'

    runBlahBlubb --successful-only
    assert_output ''

    runBlubb --successful-only
    assert_output 'blubb'

    runBlahBlubb --successful-only
    assert_output ''

    runBlah --successful-only
    assert_output 'blah'

    runBlahBlubb --successful-only
    assert_output - <<'EOF'
blah
blubb
EOF
}
