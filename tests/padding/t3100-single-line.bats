#!/usr/bin/env bats

load fixture

@test "no padding on two input lines with --single-line" {
    runWithFullOutput -0 padding --single-line <<<$'foo\nbar'
    assert_output $'foo\nbar\n'
}

@test "padding on single input line with --single-line" {
    runWithFullOutput -0 padding --single-line <<<'foo'
    assert_output $'\nfoo\n\n'
}
