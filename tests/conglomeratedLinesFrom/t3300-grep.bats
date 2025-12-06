#!/usr/bin/env bats

load fixture

runCatsAndDogs()
{
    runAnimals --grep 'cat' --grep 'dog'
}

@test "animal reporting of just cats and dogs" {
    runCatsAndDogs
    assert_output - <<'EOF'
aardvark
bird
EOF

    runCatsAndDogs
    assert_output 'elephant'

    runCatsAndDogs
    assert_output - <<'EOF'
fox
bird
dog
EOF

    runCatsAndDogs
    assert_output - <<'EOF'
cat
giraffe
dog
aardvark
EOF

    runCatsAndDogs
    assert_output - <<'EOF'
elephant
fox
horse
iguana
jellyfish
EOF

    runCatsAndDogs
    assert_output - <<'EOF'
aardvark
bird
fox
EOF

    runCatsAndDogs
    assert_output - <<'EOF'
aardvark
elephant
EOF
}

runWithoutDogs()
{
    runAnimals --vgrep 'dog'
}

@test "animal reporting without dogs" {
    runWithoutDogs
    assert_output 'dog'

    runWithoutDogs
    assert_output - <<'EOF'
dog
dog
EOF

    runWithoutDogs
    assert_output 'dog'

    runWithoutDogs
    assert_output - <<'EOF'
cat
dog
EOF

    runWithoutDogs
    assert_output ''

    runWithoutDogs
    assert_output 'fox'

    runWithoutDogs
    assert_output - <<'EOF'
aardvark
dog
EOF
}
