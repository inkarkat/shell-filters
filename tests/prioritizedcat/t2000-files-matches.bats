#!/usr/bin/env bats

load fixture

@test "Matching PATTERN lines are printed" {
    run -0 prioritizedcat 'foo\|bar' "${BATS_TEST_DIRNAME}/input.txt"
    assert_output - <<'EOF'
It is foobar.
A former admiral in a bar.
EOF
}

@test "Matching -e -e lines are printed" {
    run -0 prioritizedcat -e foo --regexp bar "${BATS_TEST_DIRNAME}/input.txt"
    assert_output - <<'EOF'
It is foobar.
A former admiral in a bar.
EOF
}

@test "A non-matching pattern prints the entire file" {
    run -0 prioritizedcat doesNotMatch -- "${BATS_TEST_DIRNAME}/input.txt"
    assert_output - < "${BATS_TEST_DIRNAME}/input.txt"
}
