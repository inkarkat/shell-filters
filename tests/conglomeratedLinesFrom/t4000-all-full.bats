#!/usr/bin/env bats

load fixture

export CONGLOMERATEDLINESFROM_DATE_FORMAT='%T'

runAllAnimals()
{
    runAnimals --all
}

@test "all animal reporting" {
    NOW=1764858240.000000000 runAllAnimals
    assert_output ''

    NOW=1764858241.000000000 runAllAnimals
    assert_output ''

    NOW=1764858242.000000000 runAllAnimals
    assert_output - <<'EOF'
dog
Previously at 15:24:00, 15:24:01 (2)
EOF

    NOW=1764858243.000000000 runAllAnimals
    assert_output - <<'EOF'
cat
Previously at 15:24:00, 15:24:01
dog
Previously at 15:24:00, 15:24:01 (2), 15:24:02
EOF

    NOW=1764858244.000000000 runAllAnimals
    assert_output ''

    NOW=1764858245.000000000 runAllAnimals
    assert_output - <<'EOF'
fox
Previously at 15:24:02, 15:24:04
EOF

    NOW=1764858246.000000000 runAllAnimals
    assert_output - <<'EOF'
aardvark
Previously at 15:24:03, 15:24:05
EOF

    NOW=1764858250.000000000 runAllAnimals
    assert_output - <<'EOF'
aardvark
Previously at 15:24:05, 15:24:06
EOF

    # Do another (partial) round to verify the reporting of the duplicate "dog"
    # line.
    NOW=1764858251.000000000 runAllAnimals
    assert_output - <<'EOF'
cat
Previously at 15:24:05, 15:24:10
dog
Previously at 15:24:06, 15:24:10
dog
EOF

    NOW=1764858252.000000000 runAllAnimals
    assert_output - <<'EOF'
dog
Previously at 15:24:06, 15:24:10, 15:24:11 (2)
EOF
}
