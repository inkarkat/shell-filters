#!/usr/bin/env bats

load fixture

runBlah()
{
    run conglomeratedLinesFrom --id same -- echo blah
}

runBlubb()
{
    run conglomeratedLinesFrom --id same -- echo blubb
}

runBlahBlubb()
{
    run conglomeratedLinesFrom --id same -- printf '%s\n' blah blubb
}

@test "different commands with the same ID are one entity" {
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
