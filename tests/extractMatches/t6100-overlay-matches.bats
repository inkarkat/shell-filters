#!/usr/bin/env bats

load overlay

@test "single matches in a line are overlaid" {
    input="Just some text.
This has foo in it.
All simple lines.
More foo here.
Seriously."
    run extractMatches --to overlay --regexp fo+ <<<"$input"
    [ "$output" = "Just some text.
This has foo in it.
${R}foo${N}All simple lines.
${R}foo${N}More foo here.
${R}foo${N}Seriously.
${R}foo${N}" ]
}

@test "three different matches with different single / global are overlaid" {
    input="Just some sexy text.
This has foo, foo and foofoo in it.
All simple lines.
More foo here.
Seriously, why?"
    run extractMatches --to overlay --regexp fo+ --global --regexp 'ex' --regexp 'y' --global <<<"$input"
    [ "$output" = "Just some sexy text.
${R}y${N}This has foo, foo and foofoo in it.
${R}foo${N}All simple lines.
${R}foo${N}More foo here.
${R}foo${N}Seriously, why?
${R}y${N}" ]
}
