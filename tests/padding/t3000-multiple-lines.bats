#!/usr/bin/env bats

load fixture

@test "no padding on single input line with --multiple-lines" {
    runWithFullOutput -0 padding --multiple-lines <<<'foo'
    assert_output $'foo\n'
}

@test "padding on two input lines with --multiple-lines" {
    runWithFullOutput -0 padding --multiple-lines <<<$'foo\nbar'
    assert_output $'\nfoo\nbar\n\n'
}
