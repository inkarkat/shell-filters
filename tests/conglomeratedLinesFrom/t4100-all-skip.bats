#!/usr/bin/env bats

load fixture

runAllAnimalsOnly()
{
    # Disable historical date formatting, as the data itself contains timestamps.
    CONGLOMERATEDLINESFROM_DATE_FORMAT='' \
	run conglomeratedLinesFrom --all --skip '^[-0-9 :]+\t' --skip '\t[[:digit:]]+\t[[:alpha:]]+$' -- dishOutSections --wrap --basedir "$BATS_TEST_TMPDIR" -- "${BATS_TEST_DIRNAME}/animal-sightings.tsv"
}

@test "all animal reporting without historical dates" {
    NOW=1764858240.000000000 runAllAnimalsOnly
    assert_output ''

    NOW=1764858241.000000000 runAllAnimalsOnly
    assert_output ''

    NOW=1764858242.000000000 runAllAnimalsOnly
    assert_output - <<'EOF'
2025-11-10 20:00	dog	1	night
2025-11-11 05:07	dog	2	night
2025-11-11 15:44	dog	3	day
2025-11-12 11:14	dog	7	day
EOF

    NOW=1764858243.000000000 runAllAnimalsOnly
    assert_output - <<'EOF'
2025-11-10 16:30	cat	2	day
2025-11-11 05:05	cat	1	night
2025-11-13 09:19	cat	1	day
2025-11-10 20:00	dog	1	night
2025-11-11 05:07	dog	2	night
2025-11-11 15:44	dog	3	day
2025-11-12 11:14	dog	7	day
2025-11-13 19:16	dog	3	day
EOF

    NOW=1764858244.000000000 runAllAnimalsOnly
    assert_output ''

    NOW=1764858245.000000000 runAllAnimalsOnly
    assert_output - <<'EOF'
2025-11-12 08:55	fox	1	day
2025-11-14 06:52	fox	1	day
2025-11-15 07:17	fox	1	day
EOF

    NOW=1764858246.000000000 runAllAnimalsOnly
    assert_output - <<'EOF'
2025-11-13 22:48	aardvark	1	night
2025-11-15 00:14	aardvark	1	night
2025-11-16 20:01	aardvark	1	night
EOF

    # Do another (partial) round to verify the reporting of the duplicate "dog"
    # line.
    NOW=1764858251.000000000 runAllAnimalsOnly
    assert_output - <<'EOF'
2025-11-15 00:14	aardvark	1	night
2025-11-16 20:01	aardvark	1	night
2025-11-10 10:22	aardvark	1	day
EOF

    NOW=1764858252.000000000 runAllAnimalsOnly
    assert_output - <<'EOF'
2025-11-15 05:55	cat	2	night
2025-11-10 16:30	cat	2	day
2025-11-11 05:05	cat	1	night
2025-11-16 21:05	dog	1	night
2025-11-10 20:00	dog	1	night
2025-11-11 05:07	dog	2	night
2025-11-11 15:44	dog	3	day
EOF
}


runAllAnimalVowels()
{
    CONGLOMERATEDLINESFROM_DATE_FORMAT='%T' \
	runAnimals --all --match '[aeiou]'
}

@test "all animal vowel reporting" {
    NOW=1764858240.000000000 runAllAnimalVowels
    assert_output ''

    NOW=1764858241.000000000 runAllAnimalVowels
    assert_output ''

    NOW=1764858242.000000000 runAllAnimalVowels
    assert_output - <<'EOF'
15:24:00	dog
15:24:01	dog
15:24:01	dog
fox
dog
EOF

    NOW=1764858243.000000000 runAllAnimalVowels
    assert_output - <<'EOF'
15:24:00	cat
15:24:01	cat
cat
15:24:00	dog
15:24:01	dog
15:24:01	dog
15:24:02	fox
15:24:02	dog
dog
EOF

    NOW=1764858244.000000000 runAllAnimalVowels
    assert_output - <<'EOF'
15:24:01	dog
15:24:01	dog
15:24:02	fox
15:24:02	dog
15:24:03	dog
fox
EOF

    NOW=1764858245.000000000 runAllAnimalVowels
    assert_output - <<'EOF'
15:24:02	fox
15:24:02	dog
15:24:03	dog
15:24:04	fox
fox
EOF

    NOW=1764858246.000000000 runAllAnimalVowels
    assert_output - <<'EOF'
15:24:03	aardvark
15:24:05	aardvark
aardvark
15:24:03	dog
15:24:04	fox
15:24:05	fox
dog
EOF
}
