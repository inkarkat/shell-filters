#!/usr/bin/env bats

load fixture

run2of3Animals()
{
    runAnimals --take 2 --record 3 "$@"
}

@test "normal 2-of-3 animal reporting" {
    run2of3Animals
    assert_output ''

    run2of3Animals
    assert_output - <<'EOF'
cat
dog
dog
EOF

    run2of3Animals
    assert_output - <<'EOF'
bird
dog
EOF

    run2of3Animals
    assert_output - <<'EOF'
cat
dog
EOF

    run2of3Animals
    assert_output 'fox'

    run2of3Animals
    assert_output - <<'EOF'
aardvark
cat
fox
EOF

    run2of3Animals
    assert_output - <<'EOF'
aardvark
elephant
EOF
}

@test "2-of-3 animal reporting with reset after print" {
    run2of3Animals --reset-after-print --reset-after-print
    assert_output ''

    run2of3Animals --reset-after-print
    assert_output - <<'EOF'
cat
dog
dog
EOF

    run2of3Animals --reset-after-print
    assert_output 'bird'

    run2of3Animals --reset-after-print
    assert_output 'dog'

    run2of3Animals --reset-after-print
    assert_output 'fox'

    run2of3Animals --reset-after-print
    assert_output - <<'EOF'
aardvark
cat
EOF

    run2of3Animals --reset-after-print
    assert_output 'elephant'
}
