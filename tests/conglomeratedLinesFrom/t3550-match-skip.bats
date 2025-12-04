#!/usr/bin/env bats

load fixture

runAnimalsOnly()
{
    run conglomeratedLinesFrom --match '\t[[:alpha:]]+' --skip '\t[[:digit:]]+\t[[:alpha:]]+$' -- dishOutSections --basedir "$BATS_TEST_TMPDIR" -- "${BATS_TEST_DIRNAME}/animal-sightings.tsv"
}

@test "animal sightings reporting skipping timestamp, counts, and day" {
    runAnimalsOnly
    assert_output ''

    runAnimalsOnly
    assert_output ''

    runAnimalsOnly
    assert_output '2025-11-12 11:14	dog	7	day'

    runAnimalsOnly
    assert_output - <<'EOF'
2025-11-13 09:19	cat	1	day
2025-11-13 19:16	dog	3	day
EOF

    runAnimalsOnly
    assert_output ''

    runAnimalsOnly
    assert_output '2025-11-15 07:17	fox	1	day'

    runAnimalsOnly
    assert_output '2025-11-16 20:01	aardvark	1	night'
}
