#!/usr/bin/env bats

load fixture

runStdinAnimals()
{
    run conglomeratedLinesFrom --id animals
}

@test "stdin animal reporting with default counts" {
    runStdinAnimals <<'EOF'
aardvark
bird
cat
dog
EOF
    assert_output ''

    runStdinAnimals <<'EOF'
cat
dog
dog
elephant
EOF
    assert_output ''

    runStdinAnimals <<'EOF'
fox
bird
dog
EOF
    assert_output 'dog'

    runStdinAnimals <<'EOF'
cat
giraffe
dog
aardvark
EOF
    assert_output - <<'EOF'
cat
dog
EOF

    runStdinAnimals <<'EOF'
elephant
fox
horse
iguana
jellyfish
EOF
    assert_output ''

    runStdinAnimals <<'EOF'
aardvark
bird
cat
fox
EOF
    assert_output 'fox'

    runStdinAnimals <<'EOF'
aardvark
dog
elephant
EOF
    assert_output 'aardvark'
}
