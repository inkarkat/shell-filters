#!/usr/bin/env bats

inputWrapper()
{
    local input="$1"; shift
    printf "%s${input:+\n}" "$input" | "$@"
}
runWithInput()
{
    run inputWrapper "$@"
}

@test "Matching PATTERN line from input are printed" {
    runWithInput $'my\nfoobar\ngaga' prioritizedcat 'foo'
    [ $status -eq 0 ]
    [ "$output" = "foobar" ]
}

@test "Matching PATTERN line from input are omitted" {
    runWithInput $'my\nfoobar\ngaga' prioritizedcat --invert-match 'foo'
    [ $status -eq 0 ]
    [ "$output" = "my
gaga" ]
}

@test "A non-matching pattern prints the entire input" {
    INPUT=$'my\nfoobar\ngaga'
    runWithInput "$INPUT" prioritizedcat doesNotMatch
    [ $status -eq 0 ]
    [ "$output" = "$INPUT" ]
}
