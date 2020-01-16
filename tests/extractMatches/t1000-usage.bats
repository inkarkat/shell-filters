#!/usr/bin/env bats

@test "error when no patterns are passed" {
    run extractMatches
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: No -e|--regexp|-c|--count|-M|--match-count|-x|--reset passed." ]
    [ "${lines[1]%% *}" = 'Usage:' ]
}

@test "invalid option prints message and usage instructions" {
  run extractMatches --invalid-option
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: Unknown option "--invalid-option"!' ]
    [ "${lines[1]%% *}" = 'Usage:' ]
}

@test "-h prints long usage help" {
  run extractMatches -h
    [ $status -eq 0 ]
    [ "${lines[0]%% *}" != 'Usage:' ]
}

@test "error when replacement is passed before regexp" {
    run extractMatches --replacement bar --regexp foo
    [ $status -eq 2 ]
    [ "${lines[0]}" = "Need -e|--regexp|-c|--count|-M|--match-count PATTERN before passing REPLACEMENT." ]
}

@test "error when global is passed before regexp" {
    run extractMatches --global --regexp foo
    [ $status -eq 2 ]
    [ "${lines[0]}" = "Need -e|--regexp|-c|--count|-M|--match-count PATTERN before passing -g|--global." ]
}

@test "error when name is passed before regexp" {
    run extractMatches --name bar --regexp foo
    [ $status -eq 2 ]
    [ "${lines[0]}" = "Need -e|--regexp|-c|--count|-M|--match-count|--reset-name PATTERN before passing NAME." ]
}

@test "error when priority is passed before regexp" {
    run extractMatches --priority 5 --regexp foo
    [ $status -eq 2 ]
    [ "${lines[0]}" = "Need -e|--regexp|-c|-count|-M|--match-count|--reset-name PATTERN before passing PRIORITY." ]
}

@test "error when priority is not numeric" {
    run extractMatches --regexp foo --priority A10N
    [ $status -eq 2 ]
    [ "${lines[0]}" = "PRIORITY must be a number." ]
}
@test "error when replacement is passed after reset" {
    run extractMatches --regexp foo --reset fox --replacement bar
    [ $status -eq 2 ]
    [ "${lines[0]}" = "Need -e|--regexp|-c|--count|-M|--match-count PATTERN before passing REPLACEMENT." ]
}

@test "error when replacement is passed after reset-name" {
    run extractMatches --reset-name fox-name --replacement bar
    [ $status -eq 2 ]
    [ "${lines[0]}" = "Need -e|--regexp|-c|--count|-M|--match-count PATTERN before passing REPLACEMENT." ]
}

@test "error when global is passed after reset" {
    run extractMatches --regexp foo --reset fox --global
    [ $status -eq 2 ]
    [ "${lines[0]}" = "Need -e|--regexp|-c|--count|-M|--match-count PATTERN before passing -g|--global." ]
}

@test "error when reset is passed after reset-name" {
    run extractMatches --reset-name foo --reset fox
    [ $status -eq 2 ]
    [ "${lines[0]}" = "Need -e|--regexp|-c|--count|-M|--match-count PATTERN before passing RESET-PATTERN." ]
}

@test "error when reset-other is passed after reset-name" {
    run extractMatches --reset-name foo --reset-other fox
    [ $status -eq 2 ]
    [ "${lines[0]}" = "Need -e|--regexp|-c|--count|-M|--match-count PATTERN before passing --reset-other NAME." ]
}

@test "error when pattern argument is missing" {
    run extractMatches --regexp
    [ $status -eq 1 ]
}

@test "error when empty pattern is passed" {
    run extractMatches --regexp ''
    [ $status -eq 1 ]
}

@test "error when multiple --to are passed" {
    run extractMatches --to title --to overlay --regexp foo
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: There can be only one --to / --grep-..." ]
}

@test "error when --to and --grep-only-matching are passed" {
    run extractMatches --to title --grep-only-matching --regexp foo
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: There can be only one --to / --grep-..." ]
}

@test "error when --to and --grep-count are passed" {
    run extractMatches --to title --grep-count --regexp foo
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: There can be only one --to / --grep-..." ]
}

@test "error when --grep-only-matching and --grep-count are passed" {
    run extractMatches --grep-only-matching --grep-count --regexp foo
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: There can be only one --to / --grep-..." ]
}
