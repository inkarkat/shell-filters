#!/usr/bin/env bats

load fixture

@test "command animal reporting with taking all four occurrences" {
    runAnimals --take 4
    assert_output ''

    runAnimals --take 4
    assert_output ''

    runAnimals --take 4
    assert_output ''

    runAnimals --take 4
    assert_output 'dog'

    runAnimals --take 4
    assert_output ''

    runAnimals --take 4
    assert_output ''

    runAnimals --take 4
    assert_output ''
}

@test "command animal reporting with taking just two occurrences of four" {
    runAnimals --take 2
    assert_output ''

    runAnimals --take 2
    assert_output - <<'EOF'
cat
dog
dog
EOF

    runAnimals --take 2
    assert_output - <<'EOF'
bird
dog
EOF

    runAnimals --take 2
    assert_output - <<'EOF'
cat
dog
aardvark
EOF

    runAnimals --take 2
    assert_output - <<'EOF'
elephant
fox
EOF

    runAnimals --take 2
    assert_output - <<'EOF'
aardvark
bird
cat
fox
EOF

    runAnimals --take 2
    assert_output - <<'EOF'
aardvark
dog
elephant
EOF
}

@test "command animal reporting with taking one occurrence prints input as-is" {
    runAnimals --take 1
    assert_output - <<'EOF'
aardvark
bird
cat
dog
EOF

    runAnimals --take 1
    assert_output - <<'EOF'
cat
dog
dog
elephant
EOF

    runAnimals --take 1
    assert_output - <<'EOF'
fox
bird
dog
EOF

    runAnimals --take 1
    assert_output - <<'EOF'
cat
giraffe
dog
aardvark
EOF

    runAnimals --take 1
    assert_output - <<'EOF'
elephant
fox
horse
iguana
jellyfish
EOF

    runAnimals --take 1
    assert_output - <<'EOF'
aardvark
bird
cat
fox
EOF

    runAnimals --take 1
    assert_output - <<'EOF'
aardvark
dog
elephant
EOF
}
