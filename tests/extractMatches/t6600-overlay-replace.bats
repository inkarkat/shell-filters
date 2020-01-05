#!/usr/bin/env bats

export input="This has foo in it.
More fooo here."
load overlay

@test "prefix replacement of match is overlaid" {
    run extractMatches --to overlay --regexp fo+ --replacement "FOO: &" <<<"$input"
    [ "$output" = "This has foo in it.
${R}FOO: foo${N}More fooo here.
${R}FOO: fooo${N}" ]
}

@test "capture group replacement of match and count is overlaid" {
    run extractMatches --to overlay --regexp '(f)(o+)' --replacement "\1-\2" --count '\<(\w)\w{2}(\w)\>' --replacement "\1-\2" <<<"$input"
    [ "$output" = "This has foo in it.
${R}T-s:1|f-oo${N}More fooo here.
${R}M-e:2|f-ooo${N}" ]
}

@test "plain replacements of count does not affect counting, only overlaying" {
    run extractMatches --to overlay --count fo+ --global --replacement "FOO" --count 'i\w' --global --replacement "FOO" <<<"$input"
    [ "$output" = "This has foo in it.
${R}FOO:1|FOO:3${N}More fooo here.
${R}FOO:2|FOO:3${N}" ]
}

@test "capture group replacements of match-count that condense characters affects counting and overlay" {
    input="This moooo mooo moo has foo in it.
More fooo here. moooo moo"
    run extractMatches --to overlay --match-count '([fm])(o)+' --global --replacement "\1\2" <<<"$input"
    [ "$output" = "This moooo mooo moo has foo in it.
${R}fo:1|mo:3${N}More fooo here. moooo moo
${R}fo:2|mo:5${N}" ]
}
