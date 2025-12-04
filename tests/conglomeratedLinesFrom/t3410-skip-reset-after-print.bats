#!/usr/bin/env bats

load fixture

run2of3AnimalsOnly()
{
    run conglomeratedLinesFrom "$@" --take 2 --record 3 --skip '^[-0-9 :]+\t' --skip '\t[[:digit:]]+\t[[:alpha:]]+$' -- dishOutSections --basedir "$BATS_TEST_TMPDIR" -- "${BATS_TEST_DIRNAME}/animal-sightings.tsv"
}

@test "2-of-3 animal sightings reporting skipping timestamp, counts, and day with reset after print" {
    run2of3AnimalsOnly --reset-after-print
    assert_output ''

    run2of3AnimalsOnly --reset-after-print
    assert_output - <<'EOF'
2025-11-11 05:05	cat	1	night
2025-11-11 05:07	dog	2	night
2025-11-11 15:44	dog	3	day
EOF

    run2of3AnimalsOnly --reset-after-print
    assert_output '2025-11-12 09:08	bird	2	day'

    run2of3AnimalsOnly --reset-after-print
    assert_output '2025-11-13 19:16	dog	3	day'

    run2of3AnimalsOnly --reset-after-print
    assert_output '2025-11-14 06:52	fox	1	day'

    run2of3AnimalsOnly --reset-after-print
    assert_output - <<'EOF'
2025-11-15 00:14	aardvark	1	night
2025-11-15 05:55	cat	2	night
EOF

    run2of3AnimalsOnly --reset-after-print
    assert_output '2025-11-16 22:31	elephant	2	night'
}
