#!/usr/bin/env bats

load fixture

@test "invalid palette prints message and usage instructions" {
    run -2 highlightRelativeAge --palette doesNotExist
    assert_line -n 0 'ERROR: Invalid palette: doesNotExist'
    assert_line -n 2 -e '^Usage:'
}
