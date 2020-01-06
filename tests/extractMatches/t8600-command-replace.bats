#!/usr/bin/env bats

export input="This has foo in it.
More fooo here."
load command

@test "prefix replacement of match is passed to command" {
    run extractMatches --to command --regexp fo+ --replacement "FOO: &" <<<"$input"
    [ "$output" = "$input" ]
    assert_runs "FOO: foo
FOO: fooo"
}

@test "capture group replacement of match and count is passed to command" {
    run extractMatches --to command --regexp '(f)(o+)' --replacement "\1-\2" --count '\<(\w)\w{2}(\w)\>' --replacement "\1-\2" <<<"$input"
    [ "$output" = "$input" ]
    assert_runs "T-s:1|f-oo
M-e:2|f-ooo"
}

@test "plain replacements of count does not affect counting, only passing to command" {
    run extractMatches --to command --count fo+ --global --replacement "FOO" --count 'i\w' --global --replacement "FOO" <<<"$input"
    [ "$output" = "$input" ]
    assert_runs "FOO:1|FOO:3
FOO:2|FOO:3"
}

@test "capture group replacements of match-count that condense characters affects counting and passing to command" {
    input="This moooo mooo moo has foo in it.
More fooo here. moooo moo"
    run extractMatches --to command --match-count '([fm])(o)+' --global --replacement "\1\2" <<<"$input"
    [ "$output" = "$input" ]
    assert_runs "fo:1|mo:3
fo:2|mo:5"
}
