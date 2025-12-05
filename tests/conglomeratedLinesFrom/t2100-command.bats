#!/usr/bin/env bats

load fixture

@test "command animal reporting with default counts" {
    runAnimals
    assert_output ''

    runAnimals
    assert_output ''

    runAnimals
    assert_output 'dog'

    runAnimals
    assert_output - <<'EOF'
cat
dog
EOF

    runAnimals
    assert_output ''

    runAnimals
    assert_output 'fox'

    runAnimals
    assert_output 'aardvark'
}
