#!/usr/bin/env bats

load fixture

@test "custom padding before" {
    runWithFullOutput -0 padding --before 'VVV' <<<$'foo\nbar'
    assert_output $'VVV\nfoo\nbar\n\n'
}

@test "custom padding after" {
    runWithFullOutput -0 padding --after '^^^' <<<$'foo\nbar'
    assert_output $'\nfoo\nbar\n^^^\n'
}

@test "custom padding before and after" {
    runWithFullOutput -0 padding --before '///' --after '\\\' <<<$'foo\nbar'
    assert_output $'///\nfoo\nbar\n\\\\\\\n'
}

@test "custom multiline padding before and after" {
    runWithFullOutput -0 padding --before $'Here\ncomes:' --after $'the\nend.' <<<$'foo\nbar'
    assert_output $'Here\ncomes:\nfoo\nbar\nthe\nend.\n'
}

@test "no padding before" {
    runWithFullOutput -0 padding --before '' <<<$'foo\nbar'
    assert_output $'foo\nbar\n\n'
}

@test "no padding after" {
    runWithFullOutput -0 padding --after '' <<<$'foo\nbar'
    assert_output $'\nfoo\nbar\n'
}

@test "no padding before and after is a no-op" {
    local input=$'foo\nbar'
    runWithFullOutput -0 padding --before '' --after '' <<<"$input"
    assert_output "$input"$'\n'
}
