#!/usr/bin/env bats

@test "Non-matching PATTERN lines are printed" {
    run prioritizedcat --invert-match '^Un' "${BATS_TEST_DIRNAME}/input.txt"
    [ $status -eq 0 ]
    [ "$output" = "It is foobar.
The fox is red.
A former admiral in a bar.
EOF" ]
}

@test "Non-matching -e -e lines are printed" {
    run prioritizedcat -v -e '^Un' --regexp '[Fx]' "${BATS_TEST_DIRNAME}/input.txt"
    [ $status -eq 0 ]
    [ "$output" = "It is foobar.
A former admiral in a bar." ]
}

@test "A non-matching inverted pattern prints the entire file" {
    run prioritizedcat --invert-match doesNotMatch -- "${BATS_TEST_DIRNAME}/input.txt"
    [ $status -eq 0 ]
    [ "$output" = "$(cat -- "${BATS_TEST_DIRNAME}/input.txt")" ]
}
