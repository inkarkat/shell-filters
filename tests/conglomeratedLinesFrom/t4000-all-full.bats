#!/usr/bin/env bats

load fixture

export CONGLOMERATEDLINESFROM_DATE_FORMAT='%T'

runAllAnimals()
{
    runAnimals --all "$@"
}

@test "all animal reporting" {
    NOW=1764858240.000000000 runAllAnimals
    assert_output ''

    NOW=1764858241.000000000 runAllAnimals
    assert_output ''

    NOW=1764858242.000000000 runAllAnimals
    assert_output - <<'EOF'
dog
Previously at 14:24:00, 14:24:01 (2)
EOF

    NOW=1764858243.000000000 runAllAnimals
    assert_output - <<'EOF'
cat
Previously at 14:24:00, 14:24:01
dog
Previously at 14:24:00, 14:24:01 (2), 14:24:02
EOF

    NOW=1764858244.000000000 runAllAnimals
    assert_output ''

    NOW=1764858245.000000000 runAllAnimals
    assert_output - <<'EOF'
fox
Previously at 14:24:02, 14:24:04
EOF

    NOW=1764858246.000000000 runAllAnimals
    assert_output - <<'EOF'
aardvark
Previously at 14:24:03, 14:24:05
EOF

    NOW=1764858250.000000000 runAllAnimals
    assert_output - <<'EOF'
aardvark
Previously at 14:24:05, 14:24:06
EOF

    # Do another (partial) round to verify the reporting of the duplicate "dog"
    # line.
    NOW=1764858251.000000000 runAllAnimals
    assert_output - <<'EOF'
cat
Previously at 14:24:05, 14:24:10
dog
Previously at 14:24:06, 14:24:10
dog
EOF

    NOW=1764858252.000000000 runAllAnimals
    assert_output - <<'EOF'
dog
Previously at 14:24:06, 14:24:10, 14:24:11 (2)
EOF
}

@test "customized all animal reporting" {
    export CONGLOMERATEDLINESFROM_CURRENT_LINE_PREFIX='['
    export CONGLOMERATEDLINESFROM_CURRENT_LINE_SUFFIX=']'
    export CONGLOMERATEDLINESFROM_DATE_DATE_SEPARATOR=' / '
    export CONGLOMERATEDLINESFROM_PREVIOUS_DATES_PREFIX='(Seen at '
    export CONGLOMERATEDLINESFROM_PREVIOUS_DATES_SUFFIX='.)'

    NOW=1764858240.000000000 runAllAnimals
    assert_output ''

    NOW=1764858241.000000000 runAllAnimals
    assert_output ''

    NOW=1764858242.000000000 runAllAnimals
    assert_output - <<'EOF'
[dog]
(Seen at 14:24:00 / 14:24:01 (2).)
EOF

    NOW=1764858243.000000000 runAllAnimals
    assert_output - <<'EOF'
[cat]
(Seen at 14:24:00 / 14:24:01.)
[dog]
(Seen at 14:24:00 / 14:24:01 (2) / 14:24:02.)
EOF
}

@test "all animal reporting with color highlighting" {
    NOW=1764858240.000000000 runAllAnimals --color=always
    assert_output ''

    NOW=1764858241.000000000 runAllAnimals --color=always
    assert_output ''

    NOW=1764858242.000000000 runAllAnimals --color=always
    assert_output - <<'EOF'
dog[0m
[3mPreviously at 14:24:00, 14:24:01 (2)[0m
EOF

    CONGLOMERATEDLINESFROM_COLOR_CURRENT_LINE='[31m' NOW=1764858243.000000000 runAllAnimals --color=always
    assert_output - <<'EOF'
[31mcat[0m
[3mPreviously at 14:24:00, 14:24:01[0m
[31mdog[0m
[3mPreviously at 14:24:00, 14:24:01 (2), 14:24:02[0m
EOF
}
