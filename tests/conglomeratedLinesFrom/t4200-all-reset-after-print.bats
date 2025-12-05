#!/usr/bin/env bats

load fixture

export CONGLOMERATEDLINESFROM_DATE_FORMAT='%T'

run2of3AnimalsOnly()
{
    runAnimals "$@" --take 2 --record 3 --all
}

@test "all animal reporting" {
    NOW=1764858240.000000000 run2of3AnimalsOnly --reset-after-print
    assert_output ''

    NOW=1764858241.000000000 run2of3AnimalsOnly --reset-after-print
    assert_output - <<'EOF'
cat
Previously at 14:24:00
dog
Previously at 14:24:00
dog
EOF

    NOW=1764858242.000000000 run2of3AnimalsOnly --reset-after-print
    assert_output - <<'EOF'
bird
Previously at 14:24:00
EOF

    # Note how the two dogs from the run that reset the counter are still included,
    # because only the triggering is suppressed, but not the history itself.
    NOW=1764858243.000000000 run2of3AnimalsOnly --reset-after-print
    assert_output - <<'EOF'
dog
Previously at 14:24:01 (2), 14:24:02
EOF

    NOW=1764858244.000000000 run2of3AnimalsOnly --reset-after-print
    assert_output - <<'EOF'
fox
Previously at 14:24:02
EOF

    NOW=1764858245.000000000 run2of3AnimalsOnly --reset-after-print
    assert_output - <<'EOF'
aardvark
Previously at 14:24:03
cat
Previously at 14:24:03
EOF

    NOW=1764858246.000000000 run2of3AnimalsOnly --reset-after-print
    assert_output - <<'EOF'
elephant
Previously at 14:24:04
EOF

    # Again, aardvark from 14:24:05 wasn't reported, but is included in the history
    # here.
    NOW=1764858250.000000000 run2of3AnimalsOnly --reset-after-print
    assert_output - <<'EOF'
aardvark
Previously at 14:24:05, 14:24:06
bird
Previously at 14:24:05
dog
Previously at 14:24:06
EOF
}
