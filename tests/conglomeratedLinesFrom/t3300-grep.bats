#!/usr/bin/env bats

load fixture

runCatsAndDogs()
{
    runAnimals --grep 'cat' --grep 'dog'
}

@test "animal reporting of just cats and dogs" {
    runCatsAndDogs
    assert_output ''

    runCatsAndDogs
    assert_output ''

    runCatsAndDogs
    assert_output 'dog'

    runCatsAndDogs
    assert_output - <<'EOF'
cat
dog
EOF

    runCatsAndDogs
    assert_output ''

    runCatsAndDogs
    assert_output ''

    runCatsAndDogs
    assert_output ''
}

runWithoutDogs()
{
    runAnimals --vgrep 'dog'
}

@test "animal reporting without dogs" {
    runWithoutDogs
    assert_output ''

    runWithoutDogs
    assert_output ''

    runWithoutDogs
    assert_output ''

    runWithoutDogs
    assert_output 'cat'

    runWithoutDogs
    assert_output ''

    runWithoutDogs
    assert_output 'fox'

    runWithoutDogs
    assert_output 'aardvark'
}
