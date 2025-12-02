#!/usr/bin/env bats

load fixture

@test "command animal reporting with five records" {
    runAnimals --record 5
    assert_output ''

    runAnimals --record 5
    assert_output ''

    runAnimals --record 5
    assert_output 'dog'

    runAnimals --record 5
    assert_output - <<'EOF'
cat
dog
EOF

    runAnimals --record 5
    assert_output ''

    runAnimals --record 5
    assert_output - <<'EOF'
cat
fox
EOF

    runAnimals --record 5
    assert_output 'aardvark'
}
