#!/usr/bin/env bats

load fixture

runStdinAnimals()
{
    run conglomeratedLinesFrom --id animals
}

runStdinWeather()
{
    run conglomeratedLinesFrom --id weather
}

@test "stdin animal and weather reporting in parallel" {
    runStdinWeather <<<'sunny'
    assert_output ''

    runStdinWeather <<<'sunny'
    assert_output ''

    runStdinWeather <<<'thunderstorm'
    assert_output ''

    runStdinWeather <<<'sunny'
    assert_output 'sunny'

    runStdinWeather <<<'sunny'
    assert_output 'sunny'

    runStdinWeather <<<'rainy'
    assert_output ''

    runStdinWeather <<<'rainy'
    assert_output ''

    runStdinWeather <<<'rainy'
    assert_output 'rainy'

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

    runStdinWeather <<<'icy'
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

    runStdinWeather <<<'rainy'
    assert_output 'rainy'

    runStdinWeather <<<'foggy'
    assert_output ''

    runStdinAnimals <<'EOF'
elephant
fox
horse
iguana
jellyfish
EOF
    assert_output ''

    runStdinWeather <<<'foggy'
    assert_output ''

    runStdinWeather <<<'foggy'
    assert_output 'foggy'

    runStdinWeather <<<'rainy'
    assert_output ''

    runStdinAnimals <<'EOF'
aardvark
bird
cat
fox
EOF
    assert_output 'fox'

    runStdinWeather <<<'sunny'
    assert_output ''

    runStdinWeather <<<'sunny'
    assert_output ''

    runStdinAnimals <<'EOF'
aardvark
dog
elephant
EOF
    assert_output 'aardvark'

    runStdinWeather <<<'sunny'
    assert_output 'sunny'
}
