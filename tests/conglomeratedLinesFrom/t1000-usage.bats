#!/usr/bin/env bats

load fixture

@test "no arguments prints message and usage instructions" {
    run -2 conglomeratedLinesFrom
    assert_line -n 0 'ERROR: No ID and no COMMAND(s) specified; need to pass -i|--id ID for standard input, or -c|--command "COMMANDLINE", or --exec SIMPLECOMMAND [...] ; or SIMPLECOMMAND.'
    assert_line -n 2 -e '^Usage:'
}

@test "invalid option prints message and usage instructions" {
    run -2 conglomeratedLinesFrom --invalid-option
    assert_line -n 0 'ERROR: Unknown option "--invalid-option"!'
    assert_line -n 2 -e '^Usage:'
}

@test "-h prints long usage help" {
    run -0 conglomeratedLinesFrom -h
    refute_line -n 0 -e '^Usage:'
}
