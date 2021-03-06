#!/usr/bin/env bats

load overlay

@test "single matches in a line are overlaid and finally cleared" {
    input="Just some text.
This has foo in it.
All simple lines.
More foo here.
Seriously."
    run extractMatches --to overlay --clear --regexp fo+ <<<"$input"
    [ $status -eq 0 ]
    [ "$output" = "Just some text.
This has foo in it.
${R}foo${N}All simple lines.
${R}foo${N}More foo here.
${R}foo${N}Seriously.
${R}foo${N}[s[1;1H[0K[u" ]
}

@test "no matches do not clear non-existing overlay" {
    input="Just some text.
Seriously."
    run extractMatches --to overlay --clear --regexp fo+ <<<"$input"
    [ $status -eq 1 ]
    [ "$output" = "Just some text.
Seriously." ]
}
