#!/usr/bin/env bats

load title

@test "single matches in a line are shown in title" {
    input="Just some text.
This has foo in it.
All simple lines.
More foo here.
Seriously."
    run extractMatches --to title --regexp fo+ <<<"$input"
    [ "$output" = "Just some text.
This has foo in it.
${R}foo${N}All simple lines.
More foo here.
Seriously." ]
}

@test "three different matches with different single / global are shown in title" {
    input="Just some sexy text.
This has foo, foo and foofoo in it.
All simple lines.
More foo here.
Seriously, why?"
    run extractMatches --to title --regexp fo+ --global --regexp 'ex' --regexp 'y' --global <<<"$input"
    [ "$output" = "Just some sexy text.
${R}y${N}This has foo, foo and foofoo in it.
${R}foo${N}All simple lines.
More foo here.
Seriously, why?
${R}y${N}" ]
}
