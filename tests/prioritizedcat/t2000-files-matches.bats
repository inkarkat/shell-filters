#!/usr/bin/env bats

@test "Matching PATTERN lines are printed" {
    run prioritizedcat 'foo\|bar' "${BATS_TEST_DIRNAME}/input.txt"
    [ $status -eq 0 ]
    [ "$output" = "It is foobar.
A former admiral in a bar." ]
}

@test "Matching -e -e lines are printed" {
    run prioritizedcat -e foo --regexp bar "${BATS_TEST_DIRNAME}/input.txt"
    [ $status -eq 0 ]
    [ "$output" = "It is foobar.
A former admiral in a bar." ]
}

@test "A non-matching pattern prints the entire file" {
    run prioritizedcat doesNotMatch -- "${BATS_TEST_DIRNAME}/input.txt"
    [ $status -eq 0 ]
    [ "$output" = "$(cat -- "${BATS_TEST_DIRNAME}/input.txt")" ]
}
