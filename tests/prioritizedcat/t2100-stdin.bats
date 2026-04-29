#!/usr/bin/env bats

load fixture

@test "Matching PATTERN line from input are printed" {
    run -0 prioritizedcat 'foo' <<<$'my\nfoobar\ngaga'
    assert_output 'foobar'
}

@test "Matching PATTERN line from input are omitted" {
    run -0 prioritizedcat --invert-match 'foo' <<<$'my\nfoobar\ngaga'
    assert_output - <<'EOF'
my
gaga
EOF
}

@test "A non-matching pattern prints the entire input" {
    INPUT=$'my\nfoobar\ngaga'
    run -0 prioritizedcat doesNotMatch <<<"$INPUT"
    assert_output "$INPUT"
}
