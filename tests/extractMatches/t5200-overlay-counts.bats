#!/usr/bin/env bats

load overlay

@test "single counts in a line are overlaid" {
    input="Just some text.
This has foo in it.
All simple lines.
More foo here.
Seriously."
    run extractMatches --to overlay --count fo+ <<<"$input"
    [ "$output" = "Just some text.
This has foo in it.
${R}foo:1${N}All simple lines.
${R}foo:1${N}More foo here.
${R}foo:2${N}Seriously.
${R}foo:2${N}" ]
}

@test "three different counts with different single / global are overlaid" {
    input="Just some sexy text.
This has foo, foo and foofoo in it.
All simple lines.
More foo here.
Seriously, why?"
    run extractMatches --to overlay --count fo+ --global --count 'ex' --count 'y' --global <<<"$input"
    [ "$output" = "Just some sexy text.
${R}ex:1|y:1${N}This has foo, foo and foofoo in it.
${R}foo:4|ex:1|y:1${N}All simple lines.
${R}foo:4|ex:1|y:1${N}More foo here.
${R}foo:5|ex:1|y:1${N}Seriously, why?
${R}foo:5|ex:1|y:3${N}" ]
}
