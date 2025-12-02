#!/usr/bin/env bats

load fixture

@test "non-numeric record count prints message and usage instructions" {
    run -2 conglomeratedLinesFrom --record abc -- :
    assert_line -n 0 'ERROR: Record count must be a positive non-zero number.'
    assert_line -n 2 -e '^Usage:'
}

@test "record count of 0 prints message and usage instructions" {
    run -2 conglomeratedLinesFrom --record 0 -- :
    assert_line -n 0 'ERROR: Record count must be a positive non-zero number.'
    assert_line -n 2 -e '^Usage:'
}

@test "non-numeric take count prints message and usage instructions" {
    run -2 conglomeratedLinesFrom --take abc -- :
    assert_line -n 0 'ERROR: Take count must be a positive non-zero number.'
    assert_line -n 2 -e '^Usage:'
}

@test "take count of 0 prints message and usage instructions" {
    run -2 conglomeratedLinesFrom --take 0 -- :
    assert_line -n 0 'ERROR: Take count must be a positive non-zero number.'
    assert_line -n 2 -e '^Usage:'
}

@test "take count larger than record count prints message and usage instructions" {
    run -2 conglomeratedLinesFrom --take 5 -- :
    assert_line -n 0 'ERROR: Take count must not exceed record count (4).'
    assert_line -n 2 -e '^Usage:'
}
