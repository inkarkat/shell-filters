#!/usr/bin/env bats

load fixture

@test "Non-matching PATTERN lines are printed" {
    run -0 prioritizedcat --invert-match '^Un' "${BATS_TEST_DIRNAME}/input.txt"
    assert_output - <<'END'
It is foobar.
The fox is red.
A former admiral in a bar.
EOF
END
}

@test "Non-matching -e -e lines are printed" {
    run -0 prioritizedcat -v -e '^Un' --regexp '[Fx]' "${BATS_TEST_DIRNAME}/input.txt"
    assert_output - <<'EOF'
It is foobar.
A former admiral in a bar.
EOF
}

@test "A non-matching inverted pattern prints the entire file" {
    run -0 prioritizedcat --invert-match doesNotMatch -- "${BATS_TEST_DIRNAME}/input.txt"
    assert_output - < "${BATS_TEST_DIRNAME}/input.txt"
}
