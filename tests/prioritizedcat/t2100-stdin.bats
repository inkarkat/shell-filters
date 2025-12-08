#!/usr/bin/env bats

load fixture

inputWrapper()
{
    local input="$1"; shift
    printf "%s${input:+\n}" "$input" | "$@"
}
runWithInput()
{
    typeset -a runArg=()
    if [ "$1" = '!' ] || [[ "$1" =~ ^-[0-9]+$ ]]; then
	runArg=("$1"); shift
    fi
    run "${runArg[@]}" inputWrapper "$@"
}

@test "Matching PATTERN line from input are printed" {
    runWithInput -0 $'my\nfoobar\ngaga' prioritizedcat 'foo'
    assert_output 'foobar'
}

@test "Matching PATTERN line from input are omitted" {
    runWithInput -0 $'my\nfoobar\ngaga' prioritizedcat --invert-match 'foo'
    assert_output - <<'EOF'
my
gaga
EOF
}

@test "A non-matching pattern prints the entire input" {
    INPUT=$'my\nfoobar\ngaga'
    runWithInput -0 "$INPUT" prioritizedcat doesNotMatch
    assert_output "$INPUT"
}
