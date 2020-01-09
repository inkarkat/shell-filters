#!/usr/bin/env bats

@test "single matches in a line are shown in concatenated line" {
    input="Just some text.
This has foo in it.
All simple lines.
More foo here.
Seriously."
    run extractMatches --to concatenated --regexp fo+ <<<"$input"
    [ "$output" = "Just some text.
This has foo in it.
extracted matches: foo
All simple lines.
More foo here.
Seriously." ]
}

@test "three different matches with different single / global are shown in concatenated line" {
    input="Just some sexy text.
This has foo, foo and foofoo in it.
All simple lines.
More foo here.
Seriously, why?"
    run extractMatches --to concatenated --regexp fo+ --global --regexp 'ex' --regexp 'y' --global <<<"$input"
    [ "$output" = "Just some sexy text.
extracted matches: y
This has foo, foo and foofoo in it.
extracted matches: foo
All simple lines.
More foo here.
Seriously, why?
extracted matches: y" ]
}
