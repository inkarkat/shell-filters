#!/usr/bin/env bats

load fixture

@test "error when no patterns are passed" {
    run -2 extractMatches
    assert_line -n 0 "ERROR: No -e|--regexp|-c|--count|-M|--match-count|-x|--reset passed."
    assert_line -n 1 -e '^Usage:'
}

@test "invalid option prints message and usage instructions" {
  run -2 extractMatches --invalid-option
    assert_line -n 0 'ERROR: Unknown option "--invalid-option"!'
    assert_line -n 1 -e '^Usage:'
}

@test "-h prints long usage help" {
  run -0 extractMatches -h
    refute_line -n 0 -e '^Usage:'
}

@test "error when replacement is passed before regexp" {
    run -2 extractMatches --replacement bar --regexp foo
    assert_line -n 0 "Need -e|--regexp|-c|--count|-M|--match-count PATTERN before passing REPLACEMENT."
}

@test "error when global is passed before regexp" {
    run -2 extractMatches --global --regexp foo
    assert_line -n 0 "Need -e|--regexp|-c|--count|-M|--match-count PATTERN before passing -g|--global."
}

@test "error when name is passed before regexp" {
    run -2 extractMatches --name bar --regexp foo
    assert_line -n 0 "Need -e|--regexp|-c|--count|-M|--match-count|--reset-name PATTERN before passing NAME."
}

@test "error when priority is passed before regexp" {
    run -2 extractMatches --priority 5 --regexp foo
    assert_line -n 0 "Need -e|--regexp|-c|-count|-M|--match-count|--reset-name PATTERN before passing PRIORITY."
}

@test "error when priority is not numeric" {
    run -2 extractMatches --regexp foo --priority A10N
    assert_line -n 0 "PRIORITY must be a number."
}
@test "error when replacement is passed after reset" {
    run -2 extractMatches --regexp foo --reset fox --replacement bar
    assert_line -n 0 "Need -e|--regexp|-c|--count|-M|--match-count PATTERN before passing REPLACEMENT."
}

@test "error when replacement is passed after reset-name" {
    run -2 extractMatches --reset-name fox-name --replacement bar
    assert_line -n 0 "Need -e|--regexp|-c|--count|-M|--match-count PATTERN before passing REPLACEMENT."
}

@test "error when global is passed after reset" {
    run -2 extractMatches --regexp foo --reset fox --global
    assert_line -n 0 "Need -e|--regexp|-c|--count|-M|--match-count PATTERN before passing -g|--global."
}

@test "error when reset is passed after reset-name" {
    run -2 extractMatches --reset-name foo --reset fox
    assert_line -n 0 "Need -e|--regexp|-c|--count|-M|--match-count PATTERN before passing RESET-PATTERN."
}

@test "error when reset-other is passed after reset-name" {
    run -2 extractMatches --reset-name foo --reset-other fox
    assert_line -n 0 "Need -e|--regexp|-c|--count|-M|--match-count PATTERN before passing --reset-other NAME."
}

@test "error when pattern argument is missing" {
    run -1 extractMatches --regexp
}

@test "error when empty pattern is passed" {
    run -1 extractMatches --regexp ''
}

@test "error when multiple --to are passed" {
    run -2 extractMatches --to title --to overlay --regexp foo
    assert_line -n 0 "ERROR: There can be only one --to / --grep-..."
}

@test "error when --to and --grep-only-matching are passed" {
    run -2 extractMatches --to title --grep-only-matching --regexp foo
    assert_line -n 0 "ERROR: There can be only one --to / --grep-..."
}

@test "error when --to and --grep-count are passed" {
    run -2 extractMatches --to title --grep-count --regexp foo
    assert_line -n 0 "ERROR: There can be only one --to / --grep-..."
}

@test "error when --grep-only-matching and --grep-count are passed" {
    run -2 extractMatches --grep-only-matching --grep-count --regexp foo
    assert_line -n 0 "ERROR: There can be only one --to / --grep-..."
}

@test "error when --clear is combined with --to concatenated" {
    run -2 extractMatches --to concatenated --clear --regexp foo
    assert_line -n 0 "ERROR: --clear must be combined with --to overlay."
}
