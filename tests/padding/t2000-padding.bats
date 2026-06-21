#!/usr/bin/env bats

load fixture

@test "default empty line padding above and below" {
    runWithFullOutput -0 padding <<<'foo'
    assert_output $'\nfoo\n\n'

    runWithFullOutput -0 padding <<<$'foo\n\nbar'
    assert_output $'\nfoo\n\nbar\n\n'
}

@test "default empty line padding on empty line(s)" {
    runWithFullOutput -0 padding <<<''
    assert_output $'\n\n\n'

    runWithFullOutput -0 padding <<<$'\n\n'
    assert_output $'\n\n\n\n\n'
}
