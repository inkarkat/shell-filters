#!/usr/bin/env bats

load fixture

roundtrip()
{
    reverseAnsi "${1:?}" | rev | reverseAnsi | rev
}

@test "overlap changes the contents" {
    run -0 reverseAnsi "${BATS_TEST_DIRNAME}/overlap.txt"
    refute_output - < "${BATS_TEST_DIRNAME}/overlap.txt"
}

@test "overlap roundtrip" {
    run -0 roundtrip "${BATS_TEST_DIRNAME}/overlap.txt"
    assert_output - < "${BATS_TEST_DIRNAME}/overlap.txt"
}

@test "overlap2 changes the contents" {
    run -0 reverseAnsi "${BATS_TEST_DIRNAME}/overlap2.txt"
    refute_output - < "${BATS_TEST_DIRNAME}/overlap2.txt"
}

@test "overlap2 roundtrip" {
    run -0 roundtrip "${BATS_TEST_DIRNAME}/overlap2.txt"
    assert_output - < "${BATS_TEST_DIRNAME}/overlap2.txt"
}
